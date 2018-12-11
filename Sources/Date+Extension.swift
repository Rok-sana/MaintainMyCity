//
//  Date+Extension.swift
//  MaintainMyCity
//
//  Created by swstation on 9/20/18.
//  Copyright © 2018 swstation. All rights reserved.
//

import Foundation

extension Date {
    func dayOfWeek() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, d MMMM"
        dateFormatter.locale  =  Locale(identifier: "ru-RU")
        return dateFormatter.string(from: self).capitalized
    }
}
