//
//  InternetRouter.swift
//  MaintainMyCity
//
//  Created by swstation on 9/3/18.
//  Copyright © 2018 swstation. All rights reserved.
//

import Foundation
import KeychainSwift
import Alamofire

enum Router: URLRequestConvertible {
    case readPost( parameters: Parameters)
    case loginUser(parameters: Parameters)
    case likePost(postId: String)
    case unlikePost(postId: String)
    case getCategories()
    case getSettings()
    case createPost(parameters: Parameters)
   
    static let baseURLString = "https://maintain-my-city-dev.herokuapp.com/api"
    
    var method: HTTPMethod {
        switch self {
        case .readPost:
            return .get
        case .loginUser:
            return .post
        case .likePost:
            return .get
        case .unlikePost:
            return .delete
        case .getCategories:
            return .get
        case .getSettings:
            return .get
        case .createPost:
            return .post
    
        }
    }
    
    var path: String {
        switch self {
        case .readPost:
            return "/posts"
        case .loginUser:
            return "/users/facebook_login"
        case .likePost(let postId):
            return "posts/\(postId)/like"
        case .unlikePost(let postId):
            return "posts/\(postId)/like"
        case .getCategories:
            return "/categories"
        case .getSettings:
            return "/settings"
        case .createPost:
            return "/posts/incidents"
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try Router.baseURLString.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        if let key = KeychainSwift().get("key") {
            urlRequest.setValue("Bearer \(key)", forHTTPHeaderField: "Authorization")
        }
         switch self {
         case .loginUser(let parameters):
         urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
         case .readPost(let parameters):
         urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
         case .likePost(_):
         urlRequest = try URLEncoding.default.encode(urlRequest, with: nil)
         case .unlikePost(_):
         urlRequest = try URLEncoding.default.encode(urlRequest, with: nil)
         case .getCategories():
            urlRequest = try URLEncoding.default.encode(urlRequest, with: nil)
         case .getSettings():
             urlRequest = try URLEncoding.default.encode(urlRequest, with: nil)
         case.createPost(let parameters):
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters )
        }
        return urlRequest
    }
}
