//
//  LaunchRouter.swift
//  MaintainMyCity
//
//  Created by swstation on 8/27/18.
//  Copyright © 2018 swstation. All rights reserved.
//

import Foundation
import UIKit

protocol FlowRouter: class {
    func showPerform(segue: UIStoryboardSegue) -> Bool
    func prepare(for segue: UIStoryboardSegue, sender: Any?)
    var dependencies: AppDependencies { get }
}

extension FlowRouter {
    func showPerform(segue: UIStoryboardSegue) -> Bool {
        return true
    }
}

protocol LaunchRouterType: FlowRouter {
    func showTab()
    func showLogIn()
    func showSkippedLoginNews()
    
}

class LaunchRouter: LaunchRouterType {
    
    private enum SegueType: String {
        case showMain
        case showLogIn
        case showSkippedLoginNews
    }
    
    weak var controller: UIViewController?
    
    let dependencies: AppDependencies
    init(dependencies: AppDependencies) {
        self.dependencies = dependencies
    }
    
    func start(with viewController: LaunchVC) {
        let vm = LaunchViewModel(authorizationManager: dependencies.authManager)
        vm.router = self
        self.controller = viewController
        viewController.configure(viewModel: vm, router: self)
        vm.launch()
    }
    
    fileprivate func setupLogIn(_ segue: UIStoryboardSegue) {
        guard let logIn = segue.destination as? LogInVC else {
            return
        }
        let router = LogInRouter(dependencies: dependencies)
        router.start(with: logIn)
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
        
        if let requestController = (tabController.viewControllers?[0] as? UINavigationController)?.viewControllers.first as? RequestVC {
            let requestRouter = RequestRouter(dependencies: dependencies)
            requestRouter.start(with: requestController)
        }
        
        if let newsController = (tabController.viewControllers?[1] as? UINavigationController)?.viewControllers.first as? NewsVC {
            let newsRouter = NewsRouter(dependencies: dependencies)
            newsRouter.start(with: newsController)
        }
        
        if let profileController = (tabController.viewControllers?[2] as? UINavigationController)?.viewControllers.first as? ProfileVC {
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
        case .showMain :
            setupTabController(segue)
        case .showLogIn :
            setupLogIn(segue)
        case .showSkippedLoginNews :
            setupSkippedLoginNews(segue)
        }
    }
}
extension LaunchRouter {
    func showTab() {
        controller?.performSegue(withIdentifier: SegueType.showMain, sender: nil)
    }
    
    func showLogIn() {
        controller?.performSegue(withIdentifier: SegueType.showLogIn, sender: nil)
    }
    func showSkippedLoginNews() {
        controller?.performSegue(withIdentifier: SegueType.showSkippedLoginNews, sender: nil)
    }
}
