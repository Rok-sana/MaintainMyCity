//
//  ViewController.swift
//  maintain-my-city-ios
//
//  Created by swstation on 8/23/18.
//  Copyright © 2018 swstation. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin

class LaunchVC: UIViewController {
    var router: FlowRouter!
    var viewModel: LaunchViewModelType!
    func configure(viewModel: LaunchViewModelType, router: FlowRouter) {
        self.viewModel = viewModel
        self.router = router
    }
    override func viewDidLoad() {
        super.viewDidLoad()
          
     }
   
 }

extension LaunchVC {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        router.prepare(for: segue, sender: sender)
    }
}
