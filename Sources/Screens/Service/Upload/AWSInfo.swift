//
//  Upload.swift
//  MaintainMyCity
//
//  Created by swstation on 16.10.2018.
//  Copyright © 2018 swstation. All rights reserved.
//

import Foundation

struct AWSInfoData: Codable {
    var upload: AWSInfo
    
    enum CodingKeys: String, CodingKey {
        case upload
        
    }
}

struct AWSInfo: Codable {
    
    let uploadRegion: String
    let poolID: String
    let bucketName: String
    
    enum CodingKeys: String, CodingKey {
        case uploadRegion = "upload_region"
        case poolID = "cognito_identity_pool_id"
        case bucketName = "upload_bucket_name"
    }
}
