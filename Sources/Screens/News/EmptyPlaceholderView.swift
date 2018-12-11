//
//  EmptyPlaceholderView.swift
//  MaintainMyCity
//
//  Created by swstation on 9/24/18.
//  Copyright © 2018 swstation. All rights reserved.
//

import UIKit

class EmptyPlaceholderView: UIView {
    
   var recognizerCompletion: (() -> ())?
    override init(frame: CGRect) {
        super.init(frame: frame)
        
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
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap))
        self.addGestureRecognizer(tapGesture)
       
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var tapGesture: UITapGestureRecognizer = {
        let tapGesture = UITapGestureRecognizer()
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        return tapGesture
    }()
    
  //=============================================================================================
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
        statusDowloadingLabel.textColor = .gray
        statusDowloadingLabel.font = UIFont(name: "SF Pro Display", size: 15)
        statusDowloadingLabel.sizeToFit()
        return statusDowloadingLabel
    }()
    
     //=============================================================================================
    
    var statusDowloadingActivityIndicator: UIActivityIndicatorView = {
        let statusDowloadingActivityIndicator = UIActivityIndicatorView()
        statusDowloadingActivityIndicator.translatesAutoresizingMaskIntoConstraints = false
        statusDowloadingActivityIndicator.color = .gray
        return statusDowloadingActivityIndicator
    }()
    
    @objc func didTap() {
        recognizerCompletion?()
        
    }
    func updateState( _ status: StatusLoading) {
        switch status {
        case .loading:
            tapGesture.isEnabled = false
            statusDowloadingLabel.text = " Loading... "
             statusDowloadingActivityIndicator.startAnimating()
            
        case .isData:
             tapGesture.isEnabled = false
             statusDowloadingActivityIndicator.stopAnimating()
             self.isHidden = true
            
        case .error:
             tapGesture.isEnabled = true
             statusDowloadingActivityIndicator.stopAnimating()
             statusDowloadingActivityIndicator.isHidden = true
             statusDowloadingLabel.text = " Failed to load news list" + "\n" +
            " Tap to retry "
            
        case .emptyPage:
            tapGesture.isEnabled = false
            statusDowloadingActivityIndicator.stopAnimating()
            statusDowloadingActivityIndicator.isHidden = true
            statusDowloadingLabel.text = "Empty results list"
            
        }
    }
}
