//
//  LogInRouter.swift
//  MaintainMyCity
//
//  Created by swstation on 8/28/18.
//  Copyright © 2018 swstation. All rights reserved.
//

import Foundation
import  UIKit
protocol LogInRouterType: FlowRouter {
    func fromLogIntoTab()
    func showSkippedLoginNews()
}

class LogInRouter {
    
    private enum SegueType: String {
        case showTabAuth
        case showOnlyNews
      
    }
   
    weak var controller: UIViewController?
    
    let dependencies: AppDependencies
    init(dependencies: AppDependencies) {
        self.dependencies = dependencies
    }
    
    deinit {
        print("\(self) deinit")
    }
    
    func start(with viewController: LogInVC) {
        let viewModel = LogInViewModel(authorizationManager: dependencies.authManager)
        viewModel.router = self
        self.controller = viewController
        viewController.configure(router: self, viewModel: viewModel )
        
    }
    
    fileprivate func setupSkippedLoginNews(_ segue: UIStoryboardSegue) {
        
        guard let skippedLoginNews = (segue.destination as? UINavigationController)?.viewControllers.first as? NewsVC else {
            return
        }
        let router = NewsRouter(dependencies: dependencies)
        router.start(with: skippedLoginNews)
    }
    
    fileprivate func setupTabController(_ segue: UIStoryboardSegue) {
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
        guard let identifier = segue.identifier, let segueType = SegueType(rawValue: identifier) else {
            return
        }
        switch segueType {
        case .showTabAuth :
            setupTabController(segue)
        case .showOnlyNews :
           setupSkippedLoginNews(segue)
       
    }
    
}
}
extension LogInRouter: LogInRouterType {
    func fromLogIntoTab() {
        controller?.performSegue(withIdentifier: SegueType.showTabAuth, sender: nil)
    }
    func showSkippedLoginNews() {
        controller?.performSegue(withIdentifier: SegueType.showOnlyNews, sender: nil)
    }
    
}
