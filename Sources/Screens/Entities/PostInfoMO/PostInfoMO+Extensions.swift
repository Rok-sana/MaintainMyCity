//
//  PostInfoMO+Extensions.swift
//  MaintainMyCity
//
//  Created by swstation on 9/18/18.
//  Copyright © 2018 swstation. All rights reserved.
//

import UIKit

extension PostInfoMO {
    func saveInfoPost() throws -> PostInfo? {
        let location = Location(longitude: (self.longitude as? Double)!, latitude: (self.latitude as? Double)!)
        let like = LikeOperationResponse(likes: (Int(self.likes) ), liked: (self.liked ))
        var newAssets: [Assets] = []
        if let assetsMO = self.assets {
            for asset in assetsMO {
                switch asset {
                case let asset as Assets:
                    newAssets.append(asset)
                default: break
                }
                
            }
        }
        
        if let authorMO = self.author, let author = try? authorMO.saveInfoUser(), let categoryMO = self.category,
            let createdAt = self.createdAt {
            
            return  PostInfo(author: author, location: location,
                             category: categoryMO.saveInfoCategory(),
                             id: id!, createdAt: createdAt as Date, liked: like.liked,
                             likes: like.likes, type: self.type!,
                             description: self.postDescription!, assets: newAssets,
                             address: self.address!)
            
        } else {
            return nil
        }
    }
    func setup(from postInfo: PostInfo) {
        let categoryPostInfoMo = CategoryMO()
        categoryPostInfoMo.setup(from: postInfo.category)
        let authorPostInfoMO = UserInfoMO()
        authorPostInfoMO.setup(from: postInfo.author)
        guard let loctionLatitude = postInfo.location?.latitude, let locationLongitude = postInfo.location?.longitude else { return }
        self.author = authorPostInfoMO
        self.latitude = loctionLatitude as NSNumber
        self.longitude = locationLongitude as NSNumber
        self.category = categoryPostInfoMo
        self.id = postInfo.id
        self.createdAt = postInfo.createdAt as NSDate
        self.liked = postInfo.liked
        self.likes = Int64(postInfo.likes)
        self.type = postInfo.type
        self.postDescription = postInfo.description
       // let allAssetsMO = self.assets!.allObjects as? [AssetsMO]
        for asset in postInfo.assets {
            let assetsMO = AssetsMO()
            assetsMO.setup(from: asset)
            self.addToAssets(assetsMO)
           // try? assetsMO.saveInfoAssets()
        }
        
        self.address = postInfo.address
        
    }
  
}
