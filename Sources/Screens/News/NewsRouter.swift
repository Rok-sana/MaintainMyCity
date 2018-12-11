//
//  NewsRouter.swift
//  MaintainMyCity
//
//  Created by swstation on 8/27/18.
//  Copyright © 2018 swstation. All rights reserved.
//

import Foundation
import UIKit

import CoreLocation
protocol NewsRouterType: FlowRouter {
    func showMap(with coordinate: CLLocationCoordinate2D)
    func showTabController()
}

class NewsRouter: NewsRouterType {
    
    private enum SegueType: String {
        case showMap
        case showTab
        
    }

    weak var controller: UIViewController?
    
    let dependencies: AppDependencies
    init(dependencies: AppDependencies) {
        self.dependencies = dependencies
    }
    
    deinit {
        print("\(self) deinit")
    }
    
    func start(with viewController: NewsVC) {
        let viewModel = NewsViewModel(postManager: dependencies.postManager, authManager: dependencies.authManager)
        viewModel.router = self
        self.controller = viewController
        viewController.configure(router: self, viewModel: viewModel)
    }
    
    fileprivate func toMap(_ segue: UIStoryboardSegue, sender: Any?) {
        guard let mapController = segue.destination as? MapVC, let coordinate = sender as? CLLocationCoordinate2D else { return }
        let router = MapViewRouter(dependencies: dependencies)
        router.start(with: mapController, coordinate: coordinate)
    }
    
    fileprivate func toTab(_ segue: UIStoryboardSegue) {
        guard let tabController = segue.destination as? TabController else {
            return
        }
        tabController.selectedIndex = 1
        
        if let requestController = (tabController.viewControllers?[0] as? UINavigationController)?.viewControllers.first
            as? RequestVC {
            let requestRouter = RequestRouter(dependencies: dependencies)
            requestRouter.start(with: requestController)
        }
        
        if let newsController = (tabController.viewControllers?[1] as? UINavigationController)?.viewControllers.first
            as? NewsVC {
            let newsRouter = NewsRouter(dependencies: dependencies)
            newsRouter.start(with: newsController)
        }
        
        if let profileController = (tabController.viewControllers?[2] as? UINavigationController)?.viewControllers.first
            as? ProfileVC {
            let profileRouter = ProfileRouter(dependencies: dependencies)
            profileRouter.start(with: profileController)
        }
        
        let router = TabControllerRouter(dependencies: dependencies)
        router.start(with: tabController)
    }
    
    func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let identifier = segue.identifier, let segueType = SegueType(rawValue: identifier)
            else { return }
        
        switch segueType {
        case .showMap:
            toMap(segue, sender: sender)
        case .showTab:
            toTab(segue)
            
        }
    }
}
extension NewsRouter {
    func showMap(with coordinate: CLLocationCoordinate2D) {
        controller?.performSegue(withIdentifier: SegueType.showMap, sender: coordinate)
    }
    func showTabController() {
        controller?.performSegue(withIdentifier: SegueType.showTab, sender: nil)
    }
}
