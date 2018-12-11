//
//  ProfileVC.swift
//  MaintainMyCity
//
//  Created by swstation on 8/27/18.
//  Copyright © 2018 swstation. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController {
    var router: FlowRouter!
    var viewModel: ProfileViewModelType!
    enum TypeOfSectionTableView: String, CaseIterable {
        case activity = "Активности"
        case settings = "Настройки"
        case exit = " "
        
        func cells() -> [CellType] {
            switch self {
            case .activity:
                return [.inWork, .sended, .completed, .ivent, .awards]
            case .settings:
                return [.receiveNotification, .defineLocation]
            case .exit:
                return [.leaveProfile]
            }
        }
    }
    
    enum CellType: String {
        case inWork = "Заявки в работе"
        case sended = "Отправленные"
        case completed = "Выполненные"
        case ivent = "События"
        case awards = "Награды"
        case receiveNotification = "Получать нотификации"
        case defineLocation = "Определять геопозицию"
        case leaveProfile = "Выйти из профиля"
    }
    
    @IBOutlet weak var tableView: UITableView!
    let sectionOfTableView: [TypeOfSectionTableView] = TypeOfSectionTableView.allCases
    
    func configure(router: FlowRouter, viewModel: ProfileViewModelType) {
        self.router = router
        self.viewModel = viewModel
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let navBar = self.navigationController?.navigationBar as? CustomNavigationBar {
            guard let userName = viewModel.ownerUserName else { return }
            navBar.setNavBar(largeTitle: userName, type: .profile)
            navBar.updateProgress(0.2)
        }
        self.view.backgroundColor = UIColor(red: 239 / 255.0, green: 239 / 255.0, blue: 244 / 255.0, alpha: 1)
        self.tableView.backgroundColor = UIColor(red: 239 / 255.0, green: 239 / 255.0, blue: 244 / 255.0, alpha: 1)
        
        self.tableView.tableFooterView = UIView(frame: .zero)
          navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Privacy Policy ", style: .plain, target: self, action: #selector(addTapped))
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    @objc func addTapped() { }
  
}
extension ProfileVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
         return sectionOfTableView.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return sectionOfTableView[section].cells().count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let sectionType = sectionOfTableView[indexPath.section]
        switch sectionType {
        case .activity:
            let  cell = (tableView.dequeueReusableCell( withIdentifier: "activityCell") as? ActivityTableViewCell)!
            cell.receiveAwards.isHidden = true
            let cellType = sectionType.cells()[indexPath.row]
            if  cellType == CellType.awards {
                cell.receiveAwards.isHidden = false
            }
            cell.descriptionCell.text = cellType.rawValue
            cell.countOfRequest.text = String(viewModel.getCountPostsOfCurrentUser())
            return cell
        case .settings:
            let cell = (tableView.dequeueReusableCell(withIdentifier: "settingsCell") as? SettingsTableViewCell)!
            cell.descriptionSettingsCell.text = sectionType.cells()[indexPath.row].rawValue
            return cell
        case .exit:
            let cell = (tableView.dequeueReusableCell(withIdentifier: "exitCell") as? ExitTableViewCell)!
            cell.exitLabel.text = sectionType.cells()[indexPath.row].rawValue
            return cell
        }
       
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let sectionType = sectionOfTableView[indexPath.section]
        switch sectionType {
        case .exit:
            return 43.0
        default:
            return  view.bounds.height * 0.08
            
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor(red: 239 / 255.0, green: 239 / 255.0, blue: 244 / 255.0, alpha: 1)
        headerView.layer.borderWidth = 0.3
        headerView.layer.borderColor = UIColor.lightGray.cgColor
        headerView.translatesAutoresizingMaskIntoConstraints = false
        let titleLabel = UILabel()
        let cellType = sectionOfTableView[section]
        titleLabel.text = cellType.rawValue
        
        titleLabel.sizeToFit()
        titleLabel.font = UIFont(name: "SFProText-Regular", size: 13)
        titleLabel.textColor = UIColor(red: 109 / 255.0, green: 109 / 255.0, blue: 114 / 255.0, alpha: 1)
        titleLabel.frame = CGRect(x: 10, y: 50.0 - titleLabel.frame.height - 5, width: titleLabel.frame.width, height: titleLabel.frame.height)
        headerView.addSubview(titleLabel)
        return headerView
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
       let sectionType = sectionOfTableView[section]
        switch sectionType {
        case .exit:
            return 40.0
        default:
            return 50.0
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
}
