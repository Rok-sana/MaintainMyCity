//
//  SettingsTableViewCell.swift
//  MaintainMyCity
//
//  Created by admin on 12/3/18.
//  Copyright © 2018 swstation. All rights reserved.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var descriptionSettingsCell: UILabel!
    
    @IBOutlet weak var indicatorActivity: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
