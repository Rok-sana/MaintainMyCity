//
//  SetLocationViewModel.swift
//  MaintainMyCity
//
//  Created by admin on 11/26/18.
//  Copyright © 2018 swstation. All rights reserved.
//

import Foundation
protocol  SetLocationViewModelType: class {
    func getLocation(address: String?)
}

class SetLocationViewModel: SetLocationViewModelType {
    
    weak var router: SetLocationRouterType?
    private var localCompletion: ((String?) -> ())?
    
    init(locationCompletion: @escaping ((String?) -> ())) {
       self.localCompletion = locationCompletion
    }
    
    func getLocation(address: String?) {
        localCompletion?(address)
    }
}
