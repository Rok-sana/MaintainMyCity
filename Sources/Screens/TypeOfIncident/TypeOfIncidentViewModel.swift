//
//  TypeOfIncidentViewModel.swift
//  MaintainMyCity
//
//  Created by swstation on 09.10.2018.
//  Copyright © 2018 swstation. All rights reserved.
//

import Foundation

protocol TypeOfIncidentViewModelType: class {
    func fetchesCategoriesList()
    var  categoriesCount: Int { get }
    func categoryCellTitleForItem( _ index: IndexPath) -> String
    func updateSelectedCell(index: IndexPath)
    var reloadTableViewData: (() -> Void)? {get set}
    var handlerError: ((Error) -> ())? {get set}
}

class TypeOfIncidentViewModel: TypeOfIncidentViewModelType {
    
    weak var router: TypeOfIncidentRouterType?
    private let postManager: PostManagerType
    private var categories: [Category] = []
    var reloadTableViewData: (() -> Void)?
    var handlerError: ((Error) -> ())?
    private var categoryCompletion: ((Category) -> ())?
    var categoriesCount: Int = 0
    init(postManager: PostManagerType, categoryCompletion: @escaping ((Category) -> ())) {
        self.categoryCompletion = categoryCompletion
        self.postManager = postManager
        fetchesCategoriesList()
       
    }
    func categoryCellTitleForItem( _ index: IndexPath) -> String {
        let title = categories[index.row].title
        return title
    }
    
    func updateSelectedCell(index: IndexPath) {
        categoryCompletion?(categories[index.row])
    }
    
    func fetchesCategoriesList() {
        postManager.loadCategory { (result) in
            switch result {
            case .success(let categories):
              self.categories = categories.sorted { $0.title < $1.title }
              self.categoriesCount = categories.count
                DispatchQueue.main.async {
                    self.reloadTableViewData?()
                }
            case .failure(let error):
                self.handlerError?(error)
                
            }
        }
        
    }
}
