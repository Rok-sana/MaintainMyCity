//
//  MediaFile.swift
//  MaintainMyCity
//
//  Created by swstation on 16.10.2018.
//  Copyright © 2018 swstation. All rights reserved.
//

import Foundation

struct MediaFile {
    
    enum MediaFileType {
        case image, video
    }
    var type: MediaFileType
    var fileName: String
    var thumbnailImageName: String
}
