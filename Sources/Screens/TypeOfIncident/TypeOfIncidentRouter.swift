//
//  TypeOfIncidentRouter.swift
//  MaintainMyCity
//
//  Created by swstation on 09.10.2018.
//  Copyright © 2018 swstation. All rights reserved.
//

import Foundation
import UIKit

protocol TypeOfIncidentRouterType: FlowRouter {
    
}

class TypeOfIncidentRouter: TypeOfIncidentRouterType {
    
    weak var controller: UIViewController?
    let dependencies: AppDependencies
    init(dependencies: AppDependencies) {
        self.dependencies = dependencies
    }
    
    deinit {
        print("\(self) deinit")
    }
    
    func start(with viewController: TypeOfIncidentVC, completion: @escaping ((Category) -> ())) {
        let vm = TypeOfIncidentViewModel(postManager: dependencies.postManager, categoryCompletion: completion)

        vm.router = self
        self.controller = viewController
        viewController.configure(viewModel: vm, router: self)
        
    }
    
    func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}
