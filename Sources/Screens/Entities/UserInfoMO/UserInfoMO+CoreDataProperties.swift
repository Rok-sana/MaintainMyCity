//
//  UserInfoMO+CoreDataProperties.swift
//  MaintainMyCity
//
//  Created by swstation on 9/18/18.
//  Copyright © 2018 swstation. All rights reserved.
//
//

import Foundation
import CoreData

extension UserInfoMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserInfoMO> {
        return NSFetchRequest<UserInfoMO>(entityName: "UserInfoMO")
    }

    @NSManaged public var avatarUrl: String?
    @NSManaged public var id: String?
    @NSManaged public var name: String?

}
