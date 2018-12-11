//
//  CategoryMO+CoreDataProperties.swift
//  MaintainMyCity
//
//  Created by swstation on 9/18/18.
//  Copyright © 2018 swstation. All rights reserved.
//
//

import Foundation
import CoreData

extension CategoryMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CategoryMO> {
        return NSFetchRequest<CategoryMO>(entityName: "CategoryMO")
    }

    @NSManaged public var id: String?
    @NSManaged public var title: String?

}
