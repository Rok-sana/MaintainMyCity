//
//  PostInfoMO+CoreDataProperties.swift
//  MaintainMyCity
//
//  Created by swstation on 10/24/18.
//  Copyright © 2018 swstation. All rights reserved.
//
//

import Foundation
import CoreData

extension PostInfoMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PostInfoMO> {
        return NSFetchRequest<PostInfoMO>(entityName: "PostInfoMO")
    }

    @NSManaged public var address: String?
    @NSManaged public var createdAt: NSDate?
    @NSManaged public var id: String?
    @NSManaged public var latitude: NSNumber?
    @NSManaged public var liked: Bool
    @NSManaged public var likes: Int64
    @NSManaged public var longitude: NSNumber?
    @NSManaged public var postDescription: String?
    @NSManaged public var type: String?
    @NSManaged public var author: UserInfoMO?
    @NSManaged public var category: CategoryMO?
    @NSManaged public var assets: NSSet?

}

// MARK: Generated accessors for assets
extension PostInfoMO {

    @objc(addAssetsObject:)
    @NSManaged public func addToAssets(_ value: AssetsMO)

    @objc(removeAssetsObject:)
    @NSManaged public func removeFromAssets(_ value: AssetsMO)

    @objc(addAssets:)
    @NSManaged public func addToAssets(_ values: NSSet)

    @objc(removeAssets:)
    @NSManaged public func removeFromAssets(_ values: NSSet)

}
