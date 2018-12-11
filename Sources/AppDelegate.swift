//
//  AppDelegate.swift
//  maintain-my-city-ios
//
//  Created by swstation on 8/23/18.
//  Copyright © 2018 swstation. All rights reserved.
//

import UIKit
import Crashlytics
import Fabric
import FBSDKCoreKit
import FacebookCore

var fbAccessToken: AccessToken?

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Fabric.with([Crashlytics.self])
        FBSDKApplicationDelegate.sharedInstance()?.application(application, didFinishLaunchingWithOptions: launchOptions)
    
        fbAccessToken = AccessToken.current
        
        let authorizationManager = AuthorizationManager()
        let postManager = PostManager()
    
    let dependencies = AppDependencies(authManager: authorizationManager, postManager: postManager)
        
        if let launchViewController = window?.rootViewController as? LaunchVC {
            let router = LaunchRouter(dependencies: dependencies)
            router.start(with: launchViewController)
        }
        // Override point for customization after application launch.
        return true
    }
    func application(_ application: UIApplication, open url: URL ,
                     sourceApplication: String?, annotation: Any) -> Bool {
        let handled: Bool = (FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation))
        return handled
    }
    func application(_ app: UIApplication, open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        let handled: Bool = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, options: options)
         return handled
    }
     func applicationWillResignActive(_ application: UIApplication) {
      
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
       
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
       
         CoreDataManager.sharedManager.saveContext()
    }

}
