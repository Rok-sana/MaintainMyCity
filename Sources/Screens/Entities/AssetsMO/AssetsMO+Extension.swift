//
//  AssetsMO+Extension.swift
//  MaintainMyCity
//
//  Created by swstation on 10/24/18.
//  Copyright © 2018 swstation. All rights reserved.
//

import Foundation
import CoreData

extension AssetsMO {
    func saveInfoAssets() -> Assets {
        return Assets(asset: self.asset!, thumbnail: self.thumbnail ?? "")
        
    }
    
    func setup(from assets: Assets) {
        self.asset = assets.asset
        self.thumbnail = assets.thumbnail
    }
}
