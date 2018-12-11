//
//  UIViewController+Extension.swift
//  MaintainMyCity
//
//  Created by swstation on 9/3/18.
//  Copyright © 2018 swstation. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func performSegue<T>(withIdentifier identifier: T, sender: Any?) where T: RawRepresentable, T.RawValue == String {
        performSegue(withIdentifier: identifier.rawValue, sender: sender)
  }
}
