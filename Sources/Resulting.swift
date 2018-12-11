//
//  Result.swift
//  MaintainMyCity
//
//  Created by swstation on 16.10.2018.
//  Copyright © 2018 swstation. All rights reserved.
//

import Foundation

enum Resulting<Value> {
    case success(Value)
    case fail(Error)
}
