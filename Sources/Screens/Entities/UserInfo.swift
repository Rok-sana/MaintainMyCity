//
//  UserInfo.swift
//  MaintainMyCity
//
//  Created by swstation on 8/29/18.
//  Copyright © 2018 swstation. All rights reserved.
//

import Foundation

struct  UserInfo: Codable {
    var auth: Auth
    var profile: Profile
}
struct  Auth: Codable {
    var token: String
    
    enum CodingKeys: String, CodingKey {
        case token
    }
}
struct  Profile: Codable {
    var avatarUrl: String
    var email: String
    var id: String
    var name: String
    
    enum CodingKeys: String, CodingKey {
       case avatarUrl = "avatar_url"
       case email = "email"
       case id = "id"
       case name = "name"
        
    }
    
    init(avatarUrl: String,
         email: String,
         id: String,
         name: String) {
        
        self.avatarUrl = avatarUrl
        self.email = email
        self.id = id
        self.name = name
    }
}
