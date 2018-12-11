//
//  AttachmentTypeOfIncidentTableViewCell.swift
//  MaintainMyCity
//
//  Created by swstation on 09.10.2018.
//  Copyright © 2018 swstation. All rights reserved.
//

import UIKit

class AttachmentTypeOfIncidentTableViewCell: UITableViewCell {

    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var checkImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

}
