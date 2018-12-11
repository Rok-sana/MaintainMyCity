//
//  SetLocationRouter.swift
//  MaintainMyCity
//
//  Created by admin on 11/26/18.
//  Copyright © 2018 swstation. All rights reserved.
//

import Foundation
import UIKit
protocol SetLocationRouterType: FlowRouter {
   
}

class SetLocationRouter: SetLocationRouterType {
   
    let dependencies: AppDependencies
    
    private weak var controller: UIViewController?
    
    init(dependencies: AppDependencies) {
        self.dependencies = dependencies
    }
    
    func start(with viewController: SetLocationVC, completion: @escaping ((String?) -> ())) {
        let vm = SetLocationViewModel(locationCompletion: completion)
        vm.router = self
        self.controller = viewController
        viewController.configure(viewModel: vm, router: self)
    }
    func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }
    
}
