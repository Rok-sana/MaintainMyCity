//
//  CoreDataManager.swift
//  MaintainMyCity
//
//  Created by swstation on 9/4/18.
//  Copyright © 2018 swstation. All rights reserved.
//

import Foundation
import CoreData
import Alamofire
import KeychainSwift

class CoreDataManager: NSObject, NSFetchedResultsControllerDelegate {
    
    static let sharedManager = CoreDataManager()
    private override init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "maintain_my_city_ios")
        
        let description = NSPersistentStoreDescription()
        description.shouldMigrateStoreAutomatically = true
        description.shouldInferMappingModelAutomatically = true
        container.persistentStoreDescriptions =  [description]
        
        container.loadPersistentStores(completionHandler: { (_, error) in
            container.viewContext.automaticallyMergesChangesFromParent = true
            container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private lazy var backgroundContext = persistentContainer.newBackgroundContext()
    
    private var postFetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>!
    func saveContext () {
        let context = CoreDataManager.sharedManager.persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    func updatePosts(_ likes: LikeOperationResponse, postId: String?, _ resultBlock: @escaping (Result<Void>) -> Void) {
        guard let `postId` = postId else { return }
        self.persistentContainer.performBackgroundTask { (context) in
            context.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
            let fetchRequest =  NSFetchRequest<PostInfoMO>(entityName: "PostInfoMO")
            fetchRequest.predicate = NSPredicate(format: "id==%@", postId)
            let fetchedResults = try? context.fetch(fetchRequest)
            guard let posts = fetchedResults else { return }
            for post in posts {
                post.liked = likes.liked
                post.likes = Int64(likes.likes)
            }
            do {
                try context.save()
                resultBlock(.success(()))
                print("SAVED!")
            } catch let error {
                print("Could not save. \(error)")
                resultBlock(.failure(error))
            }
        }
    }
    func getPostOfCurrentUser() -> [PostInfoMO]? {
            let context = CoreDataManager.sharedManager.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<PostInfoMO>(entityName: "PostInfoMO")
            guard let name = KeychainSwift().get("name") else { return nil  }
            fetchRequest.predicate = NSPredicate(format: "author.name==%@", name )
            let fetchedResults = try? context.fetch(fetchRequest)
            guard let sortedPosts = fetchedResults else { return  [] }
            return sortedPosts
        }
    
    func insertPosts(_ posts: [PostInfo], _ resultBlock: @escaping (Result<Void>) -> Void) {
        self.persistentContainer.performBackgroundTask { (context) in
            context.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
            for post in posts {
                let categoryMO = CategoryMO(context: context)
                categoryMO.setup(from: post.category)
                
                let authorMO = UserInfoMO(context: context)
                authorMO.setup(from: post.author)
                
                let postmo = PostInfoMO(context: context)
                
                postmo.id = post.id
                postmo.longitude = NSNumber(value: post.location?.longitude ?? 0)
                postmo.latitude = NSNumber(value: post.location?.latitude ?? 0)
                postmo.liked = post.liked
                postmo.likes = Int64(post.likes)
                postmo.type = post.type
                postmo.postDescription = post.description
                postmo.createdAt = post.createdAt as NSDate
                postmo.address = post.address
                
                postmo.author = authorMO
                postmo.category = categoryMO
                
                let assetsSet = NSMutableSet()
                for asset in post.assets {
                    let assetsMO = AssetsMO(context: context)
                    assetsMO.setup(from: asset)
                    assetsSet.add(assetsMO)
//                    postmo.addToAssets(assetsMO)
                }
                
                postmo.assets = assetsSet
            }
            
            do {
                try context.save()
                resultBlock(.success(()))
                print("SAVED!")
            } catch let error {
                print("Could not save. \(error)")
                resultBlock(.failure(error))
            }
        }
    }
}
