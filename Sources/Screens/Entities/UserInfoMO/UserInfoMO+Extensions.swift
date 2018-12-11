//
//  UserInfoMO+Extensions.swift
//  MaintainMyCity
//
//  Created by swstation on 9/18/18.
//  Copyright © 2018 swstation. All rights reserved.
//

import CoreData

extension UserInfoMO {
    enum DBError: Error {
        case invalidDBData
        
    }
    
    func saveInfoUser() throws -> Author {
        guard let name = self.name, let avatar = self.avatarUrl else {
            throw DBError.invalidDBData
        }
        
        return Author(id: self.id!,
                      name: name,
                      avatarUrl: avatar)
    }
    
    func setup(from author: Author) {
        self.id = author.id
        self.name = author.name
        self.avatarUrl = author.avatarUrl
        
    }
}
