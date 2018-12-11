//
//  PostManager.swift
//  MaintainMyCity
//
//  Created by swstation on 9/4/18.
//  Copyright © 2018 swstation. All rights reserved.
//

import Foundation
import Alamofire

struct PaginationInfo {
    let pagination: Pagination
    let arrayID: [String]
}

protocol PostManagerType: class {
    func loadPosts(category: String?, cursor: String?, completion: @escaping (Result<PaginationInfo>) -> Void)
    func toggleLike(postId: String, shouldLike: Bool, completion: @escaping (Result<LikeOperationResponse>) -> Void)
    func loadCategory(completion: @escaping (Result<[Category]>) -> Void)
    func createPost(parameters: [String: Any], completion: @escaping (Result<PostInfo>) -> Void)
}
class PostManager: PostManagerType {
    
     let internetManager: InternetManagerType = InternetManager()
    
    func loadPosts(category: String?, cursor: String?, completion: @escaping (Result<PaginationInfo>) -> Void) {
    
        self.internetManager.requestPosts(category: category, nextCursor: cursor, count: 10, successBlock: { postData in
            CoreDataManager.sharedManager.insertPosts(postData.data, { result in
                switch result {
                case .failure(let error):
                    completion(.failure(error))
                case .success:
                    let arrayId  = postData.data.map {$0.id}
                    let paginationInfo = PaginationInfo(pagination: postData.pagination, arrayID: arrayId)
                     completion(.success(paginationInfo))
                 }
              
            })
      
            }, errorBlock: { error in completion(.failure(error))})
        
    }
    
    func loadCategory(completion: @escaping (Result<[Category]>) -> Void) {
        self.internetManager.requestAllCategories(successBlock: { (category) in
            completion(.success(category))
           }, errorBlock: {error in completion(.failure(error))})
     }
    
    func toggleLike(postId: String, shouldLike: Bool, completion: @escaping (Result<LikeOperationResponse>) -> Void) {
        self.internetManager.requestLikeOfPost(postId: postId, shouldLike: shouldLike, successBlock: { newLike in
            CoreDataManager.sharedManager.updatePosts(newLike, postId: postId, { result in
                switch result {
                case .failure(let error):
                    completion(.failure(error))
                case .success:
                    let newLikes = LikeOperationResponse(likes: newLike.likes, liked: newLike.liked)
                    completion(.success(newLikes))
                }
            })
        }, errorBlock: {error in completion(.failure(error))})
    }
    
    func createPost(parameters: [String: Any], completion: @escaping (Result<PostInfo>) -> Void) {
        self.internetManager.createPost(with: parameters, successBlock: { postInfo in
            completion(.success(postInfo))
        }, errorBlock: {error in completion(.failure(error))})
        
    }
    
}
