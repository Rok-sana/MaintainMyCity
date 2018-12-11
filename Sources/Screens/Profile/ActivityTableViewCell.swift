//
//  ActivityTableViewCell.swift
//  MaintainMyCity
//
//  Created by admin on 12/3/18.
//  Copyright © 2018 swstation. All rights reserved.
//

import UIKit

class ActivityTableViewCell: UITableViewCell {
    
    @IBOutlet weak var descriptionCell: UILabel!
    
    @IBOutlet weak var receiveAwards: UIButton!
    @IBOutlet weak var rightStackview: UIStackView!
    
    @IBOutlet weak var leftStackView: UIStackView!
    
    @IBOutlet weak var countOfRequest: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        receiveAwards.backgroundColor = UIColor(red: 247 / 255.0, green: 210 / 255.0, blue: 34 / 255.0, alpha: 1.0)
        receiveAwards.layer.cornerRadius = 10.0
        
        receiveAwards.setTitle("Забрать награду", for: .normal)
        receiveAwards.setTitleColor(.white, for: .normal)
        receiveAwards.contentEdgeInsets  = UIEdgeInsets(top: 5.0, left: 10.0, bottom: 5.0, right: 10.0)
        countOfRequest.textColor = UIColor(red: 142 / 255.0, green: 142 / 255.0, blue: 147 / 255.0, alpha: 1.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
