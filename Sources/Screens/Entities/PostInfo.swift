//
//  PostInfo.swift
//  MaintainMyCity
//
//  Created by swstation on 9/3/18.
//  Copyright © 2018 swstation. All rights reserved.
//

import Foundation

struct PostInfo: Codable {
    var author: Author
    var location: Location?
    var category: Category
    var id: String
    var createdAt: Date
    var liked: Bool
    var likes: Int
    var type: String
    var description: String
    var assets: [Assets]
    var address: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case liked
        case likes
        case type
        case description
        case author
        case location
        case category
        case assets
        case address
    }
    
}

struct  Author: Codable {
    var id: String
    var name: String
    var avatarUrl: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case avatarUrl = "avatar_url"
    }
}

struct LikeOperationResponse: Codable {
    var likes: Int
    var liked: Bool
    
    enum CodingKeys: String, CodingKey {
        case likes
        case liked
    }
}

struct Location: Codable {
    var longitude: Double
    var latitude: Double
    
    enum CodingKeys: String, CodingKey {
        case longitude
        case latitude
    }
}

struct Category: Codable {
    var id: String
    var title: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
    }
}

struct Assets: Codable {
    var asset: String
    var thumbnail: String
    
}
