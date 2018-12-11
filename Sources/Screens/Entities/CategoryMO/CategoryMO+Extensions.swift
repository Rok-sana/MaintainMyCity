//
//  CategoryMO+Extensions.swift
//  MaintainMyCity
//
//  Created by swstation on 9/18/18.
//  Copyright © 2018 swstation. All rights reserved.
//

import CoreData

extension CategoryMO {
    func saveInfoCategory() -> Category {
        return Category(id: self.id!, title: self.title ?? "")
        
    }
    
    func setup(from category: Category) {
        self.id = category.id
        self.title = category.title
    }
}
