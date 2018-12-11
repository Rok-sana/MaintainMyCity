//
//  RootControllerSegue.swift
//  MaintainMyCity
//
//  Created by swstation on 8/27/18.
//  Copyright © 2018 swstation. All rights reserved.
//

import Foundation
import UIKit

class RootControllerSegue: UIStoryboardSegue {
    override func perform() {
        if let window = UIApplication.shared.delegate?.window {
            window?.rootViewController = destination
        }
    }
}
