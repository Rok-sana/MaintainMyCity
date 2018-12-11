//
//  TabVC.swift
//  MaintainMyCity
//
//  Created by swstation on 8/27/18.
//  Copyright © 2018 swstation. All rights reserved.
//

import UIKit

class TabController: UITabBarController {
    var router: FlowRouter!
        
    func configure(router: FlowRouter) {
        self.router = router
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
   
}
