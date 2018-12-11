//
//  ProfileRouter.swift
//  MaintainMyCity
//
//  Created by swstation on 8/27/18.
//  Copyright © 2018 swstation. All rights reserved.
//

import Foundation
import UIKit
protocol ProfileRouterType: FlowRouter {
    
}

class ProfileRouter: ProfileRouterType {
    weak var controller: UIViewController?
    
    let dependencies: AppDependencies
    init(dependencies: AppDependencies) {
        self.dependencies = dependencies
    }
    
    deinit {
        print("\(self) deinit")
    }
    
    func start(with viewController: ProfileVC) {
        let viewModel = ProfileViewModel(dependencies: dependencies)
        viewModel.router = self
        self.controller = viewController
        viewController.configure(router: self, viewModel: viewModel)
    }
    
    func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}
