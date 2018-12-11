//
//  EmptyUploadingView.swift
//  MaintainMyCity
//
//  Created by swstation on 18.10.2018.
//  Copyright © 2018 swstation. All rights reserved.
//

import UIKit

class EmptyUploadingView: UIView {
    
        override init(frame: CGRect) {
            super.init(frame: frame)
            self.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.9)
            
            self.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(statusDowloadingStack)
            statusDowloadingStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: self.bounds.width * 0.1).isActive = true
            statusDowloadingStack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -(self.bounds.width * 0.1)).isActive = true
            statusDowloadingStack.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            statusDowloadingStack.addArrangedSubview(statusDowloadingActivityIndicator)
            statusDowloadingStack.addArrangedSubview(statusDowloadingLabel)
            
            statusDowloadingLabel.setContentHuggingPriority(UILayoutPriority.defaultLow, for: .vertical)
            statusDowloadingLabel.setContentHuggingPriority(UILayoutPriority.defaultLow, for: .horizontal)
            statusDowloadingActivityIndicator.setContentHuggingPriority(UILayoutPriority.required, for: .horizontal)
            
            statusDowloadingActivityIndicator.setContentHuggingPriority(UILayoutPriority.required, for: .vertical)
          
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
   
        var statusDowloadingStack: UIStackView = {
            let statusDowloadingStack = UIStackView()
            statusDowloadingStack.translatesAutoresizingMaskIntoConstraints = false
            statusDowloadingStack.axis = .vertical
            statusDowloadingStack.spacing = 10.0
            statusDowloadingStack.alignment = .center
            return statusDowloadingStack
        }()
        
//=============================================================================================
        
        var statusDowloadingLabel: UILabel  = {
            let statusDowloadingLabel = UILabel()
            statusDowloadingLabel.translatesAutoresizingMaskIntoConstraints = false
            statusDowloadingLabel.numberOfLines = 0
            statusDowloadingLabel.textColor = .black
            statusDowloadingLabel.font = UIFont(name: "SF Pro Display", size: 15)
            statusDowloadingLabel.sizeToFit()
            return statusDowloadingLabel
        }()
        
//=============================================================================================
        
        var statusDowloadingActivityIndicator: UIActivityIndicatorView = {
            let statusDowloadingActivityIndicator = UIActivityIndicatorView()
            statusDowloadingActivityIndicator.translatesAutoresizingMaskIntoConstraints = false
            statusDowloadingActivityIndicator.color = .black
            return statusDowloadingActivityIndicator
        }()
  
        func updateState( _ status: StatusUploading) {
            switch status {
            case .uploading:
                self.isHidden = false
                statusDowloadingLabel.text = "Загрузка файлов..."
                 statusDowloadingActivityIndicator.startAnimating()
                
            case .finish:
                 statusDowloadingActivityIndicator.stopAnimating()
                self.isHidden = true
                
            }
        }
    }
