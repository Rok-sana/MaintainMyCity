//
//  MapViewModel.swift
//  MaintainMyCity
//
//  Created by swstation on 9/14/18.
//  Copyright © 2018 swstation. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

protocol MapViewModelType: class {
    var coordinate: CLLocationCoordinate2D { get }
}

class MapViewModel: MapViewModelType {
    weak var router: MapViewRouterType?
    
    let coordinate: CLLocationCoordinate2D
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
}
