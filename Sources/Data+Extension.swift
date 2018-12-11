//
//  Data+Extension.swift
//  MaintainMyCity
//
//  Created by swstation on 16.10.2018.
//  Copyright © 2018 swstation. All rights reserved.
//

import Foundation

extension Data {
    static func getDataFromTemp(fileName: String) -> Data? {
        let dataURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
        let data = try? Data(contentsOf: dataURL)
        return data
    }
}
