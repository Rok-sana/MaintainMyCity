//
//  PostsData.swift
//  MaintainMyCity
//
//  Created by swstation on 9/4/18.
//  Copyright © 2018 swstation. All rights reserved.
//

import Foundation

struct PostsData: Codable {
    var data: [PostInfo]
    var pagination: Pagination
    
    enum CodingKeys: String, CodingKey {
        case data
        case pagination
    }
}
