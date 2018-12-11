//
//  ExitTableViewCell.swift
//  MaintainMyCity
//
//  Created by admin on 12/6/18.
//  Copyright © 2018 swstation. All rights reserved.
//

import UIKit

class ExitTableViewCell: UITableViewCell {

    @IBOutlet weak var exitLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        exitLabel.textColor = UIColor(red: 245 / 255.0, green: 51 / 255.0, blue: 51 / 255.0, alpha: 1.0)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
