//
//  NewsViewModel.swift
//  MaintainMyCity
//
//  Created by swstation on 9/4/18.
//  Copyright © 2018 swstation. All rights reserved.
//

import Foundation
import CoreData
import CoreLocation
import UIKit
import FacebookCore
import KeychainSwift

enum StatusLoading {
    case loading
    case isData
    case emptyPage
    case error
}

enum StateExpandedCell {
    case expanded
    case notExpanded
}

protocol NewsViewModelDelegate: class {
    func refresh()
    func reloadRows(_ index: [IndexPath])
    func viewModelLoadingStatusDidChange(status: StatusLoading)
    
}

protocol NewsViewModelType {
    func loadNextDataPage(shouldRefresh: Bool)
    var  sections: Int { get }
    func numberOfRows(in section: Int) -> Int
    func cellModelForItem(at indexPath: IndexPath) -> PostCellModel?
    var  delegate: NewsViewModelDelegate? { get set }
    func filteringByCategory(at indexPath: IndexPath)
    var filterChanged: ((Bool, String?) -> Void)? { get set}
    func showMap()
    func fbLogin(vc: UIViewController)
    var didFinishAuth: ((Bool, Error?) -> Void)? {get set}
    var displayProgress: ((Bool) -> Void)? { get set }
    func dropCategory()
    var isAuthorize: Bool {get}
    func toggleLikeForItem(_ indexPath: IndexPath, isLiked: Bool)
    func setTitleDate() -> String
    func addingForExpandingStateCell(selectedCellAtIndexPath: IndexPath)
   
}

class NewsViewModel: NSObject, NewsViewModelType, NSFetchedResultsControllerDelegate {
    
    var isAuthorize: Bool {
        return authManager.authStatus == .authorized
    }
     weak var delegate: NewsViewModelDelegate?
    weak var router: NewsRouterType?
    private let postManager: PostManagerType
    private let authManager: AuthorizationManagerType
    var arrayPostId: [String] = []
    var didFinishAuth: ((Bool, Error?) -> Void)?
    var displayProgress: ((Bool) -> Void)?
    private lazy var fetchResultsController: NSFetchedResultsController<PostInfoMO> = createFetchResultController()
    private var pagination: Pagination?
    private var selectedCategory: String?
    var filterChanged: ((Bool, String?) -> Void)?
    var stateButtonLike: Bool = true
    private var setOfExpandedCellAtIndexPath = Set<String>()
    init(postManager: PostManagerType, authManager: AuthorizationManagerType) {
        self.postManager = postManager
        self.authManager = authManager
        super.init()
    }
    
    func setTitleDate() -> String {
        let today = Date()
        let dayOfWeek = today.dayOfWeek()
        return dayOfWeek.uppercased()
    }
    
    func showMap() {
        let coordinate = CLLocationCoordinate2D(latitude: 49.9863491, longitude: 36.2336092)
        router?.showMap(with: coordinate)
    }
    func addingForExpandingStateCell(selectedCellAtIndexPath: IndexPath) {
         let itemMO = fetchResultsController.object(at: selectedCellAtIndexPath)
         setOfExpandedCellAtIndexPath.insert(itemMO.id!)
    }
    func createFetchResultController() -> NSFetchedResultsController<PostInfoMO> {
        let fetchRequest =  NSFetchRequest<PostInfoMO>(entityName: "PostInfoMO")
        fetchRequest.predicate = NSPredicate(format: "id IN %@", [])
        
        fetchRequest.sortDescriptors = [ NSSortDescriptor(keyPath: \PostInfoMO.id, ascending: false) ]
        
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: CoreDataManager.sharedManager.persistentContainer.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        fetchedResultsController.delegate = self
        
        try? fetchedResultsController.performFetch()
        return fetchedResultsController
    }
    
    func refreshFetchedResultsController() {
        let predicate = NSPredicate(format: "id IN %@", arrayPostId)
        
        NSFetchedResultsController<PostInfoMO>.deleteCache(withName: nil)
        
        fetchResultsController.fetchRequest.predicate = predicate
        
        do {
            
            try fetchResultsController.performFetch()
            
            delegate?.refresh()
            
        } catch let error {
            print("\(error)")
        }
    }
    
    var sections: Int {
        return fetchResultsController.sections?.count ?? 0
    }
    
    func numberOfRows(in section: Int) -> Int {
        guard let sections = fetchResultsController.sections, section < sections.count else {
            return 0
        }
        return sections[section].numberOfObjects
    }
    
    func cellModelForItem(at indexPath: IndexPath) -> PostCellModel? {
        let itemMO = fetchResultsController.object(at: indexPath)
        let stateExpanded: StateExpandedCell
        if setOfExpandedCellAtIndexPath.contains(itemMO.id!) {
           stateExpanded = .expanded
        } else {
            stateExpanded = .notExpanded
        }
        guard let postCellModel = PostCellModel(itemMO, stateButtonLike, stateExpanded) else {
            return nil
        }
         return postCellModel
        
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .update:
            delegate?.reloadRows([indexPath!])
        default:
            print("...")
        }
    }
    func filteringByCategory(at indexPath: IndexPath) {
        let itemMO = fetchResultsController.object(at: indexPath)
        let id  = itemMO.category?.id
        updateSelectedCategory(at: id)
        let title = (itemMO.category?.title)!
        filterChanged?(true, title)
        
    }
    
    func toggleLikeForItem(_ indexPath: IndexPath, isLiked: Bool) {
        let postMO = fetchResultsController.object(at: indexPath)
        let postId = (postMO.id)!
        likedPost(isLiked: !postMO.liked, postIdForLike: postId )
        
    }
    
    func updateSelectedCategory(at id: String?) {
        self.selectedCategory = id
        loadNextDataPage(shouldRefresh: true)
    }
    
    func dropCategory() {
        updateSelectedCategory(at: nil)
        filterChanged?(false, nil)
    }
    
    func likedPost(isLiked: Bool, postIdForLike: String) {
        
        postManager.toggleLike(postId: postIdForLike, shouldLike: isLiked) { result in
            self.stateButtonLike = true
            guard let result = result.value else {
               
                return
            }
           
            let liked = result.liked
            let likes = result.likes
            print(liked)
            print(likes)
        }
    }
    
    func loadNextDataPage(shouldRefresh: Bool) {
        let cursor = shouldRefresh ? nil : pagination?.nextCursor
        delegate?.viewModelLoadingStatusDidChange(status: .loading)
        postManager.loadPosts(category: selectedCategory, cursor: cursor) { result in
            guard let result = result.value
               else {
                 self.delegate?.viewModelLoadingStatusDidChange(status: .error)
                return
            }
           
            DispatchQueue.main.async {
                let tempArray = result.arrayID
                if shouldRefresh {
                   self.arrayPostId.removeAll()
                }
                self.arrayPostId.append(contentsOf: tempArray)
                self.refreshFetchedResultsController()
                if result.arrayID.isEmpty {
                    self.delegate?.viewModelLoadingStatusDidChange(status: .emptyPage)
                } else {
                    self.delegate?.viewModelLoadingStatusDidChange(status: .isData)}
                
            }
        }
    }
    
    func fbLogin(vc: UIViewController) {
        authManager.authorize(presentVC: vc, { [weak self] loggedIn, error in
            
            DispatchQueue.main.async {
                self?.displayProgress?(false)
                self?.didFinishAuth?(loggedIn, error)}
            if loggedIn {
                self?.router?.showTabController()
            }
            }, { [weak self] in
                DispatchQueue.main.async {
                    self?.displayProgress?(true)
                }
        })
    }
}
