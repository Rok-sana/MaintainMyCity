//
//  LogInVC.swift
//  MaintainMyCity
//
//  Created by swstation on 8/28/18.
//  Copyright © 2018 swstation. All rights reserved.
//

import UIKit

class LogInVC: UIViewController {
  
    var router: LogInRouter!
    var viewModel: LogInViewModelType!
    func configure(router: LogInRouter, viewModel: LogInViewModelType) {
        self.router = router
        self.viewModel = viewModel
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.didFinishAuth = {[weak self] loggedIn, error in
            if let `error` = error {
                self?.handleError(error)
            }
        }
        
        viewModel.displayProgress = { [weak self] display in
            if let view = self?.view, display {
                LoaderView.sharedInstance.start(in: view)
            } else {
                LoaderView.sharedInstance.stop()
            }
        }
    }
    
    @IBAction func fbButton(_ sender: UIButton) {
        viewModel.fbLogin(vc: self)
    }
    
    @IBAction func authLater(_ sender: UIButton) {
         viewModel.setSkipLogin()
         router?.showSkippedLoginNews()
        
    }
    
    func handleError(_ error: Error) {
        let alert = UIAlertController(title: "Error", message: error as? String, preferredStyle: UIAlertController.Style.alert)
    
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
}
extension LogInVC {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        router.prepare(for: segue, sender: sender)
    }
}
