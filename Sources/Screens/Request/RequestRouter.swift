//
//  RequestRouter.swift
//  MaintainMyCity
//
//  Created by swstation on 8/27/18.
//  Copyright © 2018 swstation. All rights reserved.
//

import Foundation
import  UIKit

protocol RequestRouterType: FlowRouter {
    func showType(completion: @escaping (Category)->())
    func showLocation( completion: @escaping (String?) -> ())
    func prepare(for segue: UIStoryboardSegue, sender: Any?)
}

class RequestRouter: RequestRouterType {
    
    private enum SegueType: String {
        case showType
        case showLocation
        
    }
    weak var controller: UIViewController?
    
    let dependencies: AppDependencies
    init(dependencies: AppDependencies) {
        self.dependencies = dependencies
    }
    
    deinit {
        print("\(self) deinit")
    }
    
    func start(with viewController: RequestVC) {
        let viewModel = RequstViewModel(dependencies: dependencies)
        viewModel.router = self
        self.controller = viewController
        viewController.configure(router: self, viewModel: viewModel )
    }
    
    func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier, let segueType = SegueType(rawValue: identifier)
            else { return }
        
        switch segueType {
        case .showType:
            if let typeController = (segue.destination as? UINavigationController)?.viewControllers.first as? TypeOfIncidentVC, let completion = sender  as? ((Category)->()) {
                let router = TypeOfIncidentRouter(dependencies: dependencies)
                router.start(with: typeController, completion: completion)
            }
        
        case .showLocation:
            if let setLocationController = (segue.destination as? UINavigationController)?.viewControllers.first as? SetLocationVC, let completion = sender as? ((String?) -> ()) {
                let router = SetLocationRouter(dependencies: dependencies)
                router.start(with: setLocationController, completion: completion)
            }
        }
        
    }
}
extension  RequestRouter {
    func showType(completion: @escaping (Category)->()) {
        controller?.performSegue(withIdentifier: SegueType.showType, sender: completion)
}
    func showLocation(completion: @escaping (String?) -> ()) {
        controller?.performSegue(withIdentifier: SegueType.showLocation, sender: completion)
    }
}
