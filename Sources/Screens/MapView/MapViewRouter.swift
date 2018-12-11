//
//  MapViewRouter.swift
//  MaintainMyCity
//
//  Created by swstation on 9/14/18.
//  Copyright © 2018 swstation. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

protocol MapViewRouterType: FlowRouter {
    
}

class MapViewRouter: MapViewRouterType {
    
    weak var controller: UIViewController?
    let dependencies: AppDependencies
    init(dependencies: AppDependencies) {
        self.dependencies = dependencies
    }
    
    deinit {
        print("\(self) deinit")
    }
    
    func start(with viewController: MapVC, coordinate: CLLocationCoordinate2D) {
        let vm = MapViewModel(coordinate: coordinate)
        vm.router = self
        
        self.controller = viewController
        viewController.configure(viewModel: vm, router: self)
    }
    
    func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}
