//
//  LogInViewModel.swift
//  MaintainMyCity
//
//  Created by swstation on 8/28/18.
//  Copyright © 2018 swstation. All rights reserved.
//

import Foundation
import UIKit
import FacebookCore

protocol LogInViewModelType: class {
    func fbLogin(vc: UIViewController)
    func setSkipLogin()
    var didFinishAuth: ((Bool, Error?) -> Void)? {get set}
    var displayProgress: ((Bool) -> Void)? { get set }
}

class LogInViewModel: LogInViewModelType {
    weak var router: LogInRouterType?
    private let authorizationManager: AuthorizationManagerType
    var didFinishAuth: ((Bool, Error?) -> Void)?
    var displayProgress: ((Bool) -> Void)?
    
    init(authorizationManager: AuthorizationManagerType) {
        self.authorizationManager = authorizationManager
    }
    
    func setSkipLogin() {
        authorizationManager.skipLogin()
    }
    
    func fbLogin(vc: UIViewController) {
        authorizationManager.authorize(presentVC: vc, { [weak self] loggedIn, error in
            DispatchQueue.main.async {
              self?.displayProgress?(false)
              self?.didFinishAuth?(loggedIn, error)}
              if loggedIn {
                self?.router?.fromLogIntoTab()
              }
            }, { [weak self] in
              DispatchQueue.main.async {
                self?.displayProgress?(true)
              }
        })
    }
}
