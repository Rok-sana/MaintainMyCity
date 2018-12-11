//
//  AppDependencies.swift
//  MaintainMyCity
//
//  Created by swstation on 8/27/18.
//  Copyright © 2018 swstation. All rights reserved.
//

import Foundation
protocol AppDependenciesType {
    
}

struct AppDependencies: AppDependenciesType {
    let authManager: AuthorizationManagerType
    let postManager: PostManagerType
    
}
