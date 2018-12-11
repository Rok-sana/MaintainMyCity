//
//  TabControllerRouter.swift
//  MaintainMyCity
//
//  Created by swstation on 8/27/18.
//  Copyright © 2018 swstation. All rights reserved.
//

import Foundation
import UIKit

protocol TabControllerRouterType: FlowRouter {
    
}

class TabControllerRouter: TabControllerRouterType {
    
    weak var controller: UITabBarController?
    let dependencies: AppDependencies
    init(dependencies: AppDependencies) {
        self.dependencies = dependencies
    }
    
    deinit {
        print("\(self) deinit")
    }
    
    func start(with viewController: TabController) {
        self.controller = viewController
        viewController.configure(router: self)
    }
    
    func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}
