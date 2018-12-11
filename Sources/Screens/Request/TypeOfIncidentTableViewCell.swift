//
//  TypeOfIncidentTableViewCell.swift
//  MaintainMyCity
//
//  Created by swstation on 01.10.2018.
//  Copyright © 2018 swstation. All rights reserved.
//

import UIKit

class TypeOfIncidentTableViewCell: UITableViewCell {
     @IBOutlet weak var stackView: UIStackView!
 
    @IBOutlet weak var typeOfIncidentLabel: UILabel!
    
    @IBOutlet weak var segueButton: UIButton!
    //weak var viewController: TypeOfIncidentVC?
    override func awakeFromNib() {
        super.awakeFromNib()
         
    }
    func transferTypeOfincident(title: String) {
        typeOfIncidentLabel.text = title
    }
}
