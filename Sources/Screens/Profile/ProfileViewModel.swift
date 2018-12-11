//
//  ProfileViewModel.swift
//  MaintainMyCity
//
//  Created by admin on 12/6/18.
//  Copyright © 2018 swstation. All rights reserved.
//

import Foundation
import KeychainSwift

protocol ProfileViewModelType {
    var ownerUserName: String? {get set}
    func getCountPostsOfCurrentUser() -> Int
    
}
class ProfileViewModel: ProfileViewModelType {
    var postManager: PostManagerType
    var router: ProfileRouter?
    var ownerUserName: String?
    var countPostCurrenUser: Int = 0
    init(dependencies: AppDependencies) {
        self.postManager = dependencies.postManager
        receiveUserName()
    }
    func receiveUserName() {
        let fullName = KeychainSwift().get("name")
        let name = fullName?.split {$0 == " "}
        if let firstName = name?.first {
        self.ownerUserName = String(firstName)
    }
}
   func getCountPostsOfCurrentUser() -> Int {
      let posts =  CoreDataManager.sharedManager.getPostOfCurrentUser()
       let count = posts?.count ?? 0
       return count
    }
}
