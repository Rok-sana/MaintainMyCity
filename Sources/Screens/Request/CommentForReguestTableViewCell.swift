//
//  CommentForReguestTableViewCell.swift
//  MaintainMyCity
//
//  Created by swstation on 05.10.2018.
//  Copyright © 2018 swstation. All rights reserved.
//

import UIKit
protocol CommentForReguestTableViewCellDelegate: class {
    func descriptionDidChange(text: String)
}

class CommentForReguestTableViewCell: UITableViewCell, UITextViewDelegate {
    
    @IBOutlet weak var textView: UITextView!
    weak var delegate: CommentForReguestTableViewCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
         textView.delegate = self
        
    }
  
    func textViewDidChange(_ textView: UITextView) {
      self.delegate?.descriptionDidChange(text: textView.text!)
    }
    
}
