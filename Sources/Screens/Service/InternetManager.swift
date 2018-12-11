//
//  InternetManager.swift
//  MaintainMyCity
//
//  Created by swstation on 8/28/18.
//  Copyright © 2018 swstation. All rights reserved.
//

import Foundation
import Alamofire
import KeychainSwift

typealias SuccessBlock = () -> Void
typealias ErrorBlock = (Error) -> Void

protocol InternetManagerType: class {
    
    func sendFBToken(token: String, successBlock: @escaping (UserInfo) -> Void, errorBlock: @escaping ErrorBlock)
    func requestPosts(category: String?, nextCursor: String?, count: Int, successBlock: @escaping (PostsData) -> Void, errorBlock: @escaping ErrorBlock)
    func requestLikeOfPost(postId: String, shouldLike: Bool, successBlock: @escaping (LikeOperationResponse) -> Void, errorBlock: @escaping ErrorBlock)
    func requestAllCategories(successBlock: @escaping ([Category]) -> Void, errorBlock: @escaping ErrorBlock)
    func requestUploadSettings(successBlock: @escaping (AWSInfo) -> Void, errorBlock: @escaping ErrorBlock)
    func createPost(with creatingPostInfo: [String: Any], successBlock: @escaping (PostInfo) -> Void, errorBlock: @escaping ErrorBlock)
}

typealias LoginResult = String

class InternetManager: InternetManagerType {
    
    let parser: WebParserType = WebParser()
    
    func sendFBToken(token: String, successBlock: @escaping (UserInfo) -> Void, errorBlock: @escaping ErrorBlock) {
        let keyWord = ["access_token": token]
        Alamofire.request(Router.loginUser(parameters: keyWord)).validate().responseJSON { _ in
            }.responseData { [weak self] response in
                guard self != nil else { return }
                
                do {
                    let result = try WebParser.parse(UserInfo.self, from: response)
                    successBlock(result)
                } catch let error {
                    errorBlock(error)
                }
        }
    }
    
    func requestAllCategories(successBlock: @escaping ([Category]) -> Void, errorBlock: @escaping ErrorBlock) {
        Alamofire.request(Router.getCategories()).responseJSON(completionHandler: { _ in
        })
            .responseData { [weak self] responce in
                guard self != nil else {return}
                do {
                    let result = try WebParser.parse([Category].self, from: responce)
                    successBlock(result)
                } catch let error {
                    print("\(error)")
                    errorBlock(error)
                }
                
        }
        
    }
  
    func requestUploadSettings(successBlock: @escaping (AWSInfo) -> Void, errorBlock: @escaping ErrorBlock) {
        
        Alamofire.request(Router.getSettings()).responseJSON(completionHandler: { _ in
            
        })
            .responseData { [weak self] responce in
                print("GGGGGGGGGGG \(responce)")
                
                guard self != nil else {return}
                do {
                    let result = try WebParser.parse(AWSInfoData.self, from: responce)
                    successBlock( result.upload)
                } catch let error {
                    print("\(error)")
                    errorBlock(error)
                }
                
        }
        
    }
    
    func requestPosts(category: String? = nil, nextCursor: String? = nil, count: Int = 10, successBlock: @escaping (PostsData) -> Void, errorBlock: @escaping ErrorBlock) {
        
        var parameters: Parameters = [ "count": count ]
        
        if let `category` = category {
            parameters["category_id"] = category
        } else if let cursor = nextCursor {
            parameters["next_cursor"] = cursor
        }
        
        Alamofire.request(Router.readPost(parameters: parameters)).responseJSON(completionHandler: { _ in
        })
            .responseData { [weak self] response in
                guard self != nil else { return }
                
                do {
                    let result = try WebParser.parse(PostsData.self, from: response)
                    successBlock(result)
                    print(result)
                } catch let error {
                    print("\(error)")
                    errorBlock(error)
                }
        }
    }
    
    func requestLikeOfPost(postId: String, shouldLike: Bool, successBlock: @escaping (LikeOperationResponse) -> Void, errorBlock: @escaping ErrorBlock) {
        var router: Router!
        if shouldLike {
            router = .likePost(postId: postId)
        } else {
            router = .unlikePost(postId: postId)
            
        }
        
        Alamofire.request(router).responseJSON (completionHandler: { result in
            print("\(String(describing: result.result.value))")
        })
            .responseData { [weak self] responce in
                
                guard self != nil else {return}
                do {
                    let result = try WebParser.parse(LikeOperationResponse.self, from: responce)
                    successBlock(result)
                } catch let error {
                    print("\(error)")
                    errorBlock(error)
                }
                
        }
        
    }
    
    func createPost(with creatingPostInfo: [String: Any], successBlock: @escaping (PostInfo) -> Void, errorBlock: @escaping ErrorBlock) {
        let postParameters: Parameters = creatingPostInfo
        Alamofire.request(Router.createPost(parameters: postParameters)).validate().responseJSON(completionHandler: { _ in
            
        })
            .responseData { [weak self] responce in
                
                guard self != nil else {return}
                do {
                    let result = try WebParser.parse(PostInfo.self, from: responce)
                    print(result)
                    successBlock( result)
                } catch let error {
                    print("\(error)")
                    errorBlock(error)
                }
                
        }
    }

}
