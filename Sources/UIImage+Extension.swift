//
//  Image+Extension.swift
//  MaintainMyCity
//
//  Created by swstation on 05.10.2018.
//  Copyright © 2018 swstation. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    func resizeImage(targetSize: CGSize) -> UIImage {
        let size = self.size
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        let newSize = widthRatio > heightRatio ? CGSize(width: size.width * heightRatio, height: size.height * heightRatio): CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    func saveToTemp() throws -> String {
        
        let jpegImage = self.jpegData(compressionQuality: 0.8)
        let idName = UUID().uuidString
        let fileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(idName)
        try jpegImage?.write(to: fileURL)
        return idName
    }
   
}
