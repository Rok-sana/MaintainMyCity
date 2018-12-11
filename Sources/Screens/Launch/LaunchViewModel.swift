//
//  LaunchViewModel.swift
//  MaintainMyCity
//
//  Created by swstation on 8/27/18.
//  Copyright © 2018 swstation. All rights reserved.
//

import Foundation
import FacebookCore
import FacebookLogin

protocol LaunchViewModelType: class {
    func launch()
}

class LaunchViewModel: LaunchViewModelType {
    weak var router: LaunchRouterType?
    private let authorizationManager: AuthorizationManagerType
    
    init(authorizationManager: AuthorizationManagerType) {
        self.authorizationManager = authorizationManager
    }
   
    func launch() {
        switch authorizationManager.authStatus {
        case .authorized:
            router?.showTab()
        case .unauthorized:
            router?.showLogIn()
        case .skippedLogin :
            router?.showSkippedLoginNews()
            
        }
    }
}
