//
//  Pagination.swift
//  MaintainMyCity
//
//  Created by swstation on 9/4/18.
//  Copyright © 2018 swstation. All rights reserved.
//

import Foundation

struct Pagination: Codable {
    var nextCursor: String?
    var previousCursor: String?
    var hasPreviousPage: Bool
    var hasNextPage: Bool
    
    enum CodingKeys: String, CodingKey {
        case nextCursor = "next_cursor"
        case previousCursor = "previous_cursor"
        case hasPreviousPage = "has_previous_page"
        case hasNextPage = "has_next_page"
    }
}
