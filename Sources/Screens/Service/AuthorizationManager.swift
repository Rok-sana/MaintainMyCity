//
//  AuthorizationManager.swift
//  MaintainMyCity
//
//  Created by swstation on 8/27/18.
//  Copyright © 2018 swstation. All rights reserved.
//

import Foundation
import UIKit
import FacebookCore
import FacebookLogin
import Alamofire
import KeychainSwift

enum AuthorisedStatus {
    case authorized
    case skippedLogin
    case unauthorized
}
protocol AuthorizationManagerType: class {
    
    var authStatus: AuthorisedStatus { get }
    func authorize(presentVC: UIViewController, _ completion: @escaping (Bool, Error?) -> Void, _ didLoginToFB: @escaping () -> Void)
    func skipLogin()
    func getSettings() -> AWSInfo?
    
}

class AuthorizationManager: AuthorizationManagerType {
    let internetMang: InternetManagerType = InternetManager()
    enum Constants: String {
        case skippedLogin = "skipped_login"
    }
    func skipLogin() {
        self.skippedLogin = true
    }
    
    private var skippedLogin: Bool {
        get {
            return UserDefaults.standard.bool(forKey: Constants.skippedLogin.rawValue)
        }
        
        set {
            UserDefaults.standard.register(defaults: [Constants.skippedLogin.rawValue: false])
            UserDefaults.standard.set(newValue, forKey: Constants.skippedLogin.rawValue)
            UserDefaults.standard.synchronize()
        }
    }

    var authStatus: AuthorisedStatus {
        if KeychainSwift().get("key") != nil {
            return .authorized
        } else if skippedLogin {
            return .skippedLogin
        } else {
            return .unauthorized
        }
    }
    
    private func saveInKeyChain(token: String, name: String, id: String) {
        let key = KeychainSwift()
        key.set(token, forKey: "key")
        key.set(name, forKey: "name")
        key.set(id, forKey: "id")
        
    }
    func saveSettings(settings: AWSInfo) {
        if let settingsData = try? JSONEncoder().encode(settings) {
            KeychainSwift().set(settingsData, forKey: "uploadSettings")
        }
    }
   func getSettings() -> AWSInfo? {
        guard let settingsData = KeychainSwift().getData("uploadSettings"),
            let settings = try? JSONDecoder().decode(AWSInfo.self, from: settingsData) else {
                return nil
        }
        return settings
    }
    
    func authorize(presentVC: UIViewController, _ completion: @escaping (Bool, Error?) -> Void, _ didLoginToFB: @escaping () -> Void) {
        
        let loginManager = LoginManager()
        loginManager.logIn(readPermissions: [.publicProfile], viewController: presentVC) { [weak self] loginResult in
            switch loginResult {
            case .failed(let error):
                completion(false, error)
            case .cancelled:
                completion(false, nil)
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                print(grantedPermissions)
                print(declinedPermissions)
                didLoginToFB()
                
                self?.internetMang.sendFBToken(token: accessToken.authenticationToken, successBlock: { [weak self]userInfo in
                    self?.saveInKeyChain(token: userInfo.auth.token, name: userInfo.profile.name, id: userInfo.profile.id)
                    self?.internetMang.requestUploadSettings(successBlock: { awsInfo in
                        self?.saveSettings(settings: awsInfo)
                        completion(true, nil)
                    }, errorBlock: { (error) in
                        completion(false, error)
                    })
                    
                }, errorBlock: { (error) in
                    completion(false, error)
                })
                 
            }
        }
    }
}
