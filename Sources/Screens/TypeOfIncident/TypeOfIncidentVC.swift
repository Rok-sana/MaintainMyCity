//
//  TypeOfIncidentVC.swift
//  MaintainMyCity
//
//  Created by swstation on 09.10.2018.
//  Copyright © 2018 swstation. All rights reserved.
//

import UIKit

class TypeOfIncidentVC: UIViewController {
 
    var router: FlowRouter!
    var viewModel: TypeOfIncidentViewModelType!

    @IBOutlet weak var tableView: UITableView!
    
    func configure(viewModel: TypeOfIncidentViewModelType, router: FlowRouter) {
        self.router = router
        self.viewModel = viewModel
    }
    
 @objc  func back() {
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let backButton: UIBarButtonItem = UIBarButtonItem(title: "Назад", style: .plain, target: self, action: #selector(back))
        self.navigationItem.leftBarButtonItem = backButton
        self.title = "Выберите категорию"
        viewModel.reloadTableViewData = { [weak self] in
            self?.tableView.reloadData()
        }
        viewModel.handlerError = { error in
            self.handleError(error)
        }
    }
    
    func handleError(_ error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
}
extension TypeOfIncidentVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.categoriesCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell( withIdentifier: "attachmentTypeCell") as? AttachmentTypeOfIncidentTableViewCell
       let categoryCellModel = viewModel.categoryCellTitleForItem(indexPath)
        cell?.titleLabel.text = categoryCellModel

        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         viewModel.updateSelectedCell(index: indexPath)
         let cell = tableView.cellForRow(at: indexPath) as? AttachmentTypeOfIncidentTableViewCell
        UIView.animate(withDuration: 0.3) {
            cell?.checkImageView.image = UIImage(named: "checkmarkIcon")
        }
       
            self.dismiss(animated: true, completion: nil)
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
}
