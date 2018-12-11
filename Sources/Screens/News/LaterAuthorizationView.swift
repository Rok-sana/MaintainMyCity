//
//  LaterAuthorizationView.swift
//  MaintainMyCity
//
//  Created by swstation on 9/21/18.
//  Copyright © 2018 swstation. All rights reserved.
//

import UIKit

class LaterAuthorizationView: UIView {
   var completionToVC: (() -> Void)?
    override init(frame: CGRect) {
        
        super.init(frame: frame)
       
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = UIColor(red: CGFloat(254 / 255.0), green: CGFloat( 254 / 255.0), blue: CGFloat(254 / 255.0), alpha: CGFloat(1.0))
        self.addSubview(mainStack)
        mainStack.topAnchor.constraint(equalTo: self.topAnchor, constant: 40).isActive = true
        mainStack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -(self.frame.width * 0.1)).isActive = true
        mainStack.leftAnchor.constraint(equalTo: self.leftAnchor, constant: self.frame.width * 0.1).isActive = true
        mainStack.addArrangedSubview(authLabel)
        mainStack.addArrangedSubview(authButtonStack)
        authButtonStack.addArrangedSubview(fbButton)
        authButtonStack.addArrangedSubview(mainLaterView)
        fbButton.setContentHuggingPriority(UILayoutPriority.defaultLow, for: .vertical)
        fbButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        fbButton.widthAnchor.constraint(equalToConstant: self.frame.width * 0.5).isActive = true
        fbButton.setContentHuggingPriority(UILayoutPriority.defaultLow, for: .horizontal)
       mainLaterView.setContentHuggingPriority(UILayoutPriority.required, for: .vertical)
        mainLaterView.setContentHuggingPriority(UILayoutPriority.required, for: .horizontal)
       mainLaterView.addSubview(laterButton)
        laterButton.leadingAnchor.constraint(equalTo: mainLaterView.leadingAnchor, constant: 0).isActive = true
        laterButton.trailingAnchor.constraint(equalTo: mainLaterView.trailingAnchor).isActive = true
        laterButton.topAnchor.constraint(equalTo: mainLaterView.topAnchor).isActive = true
        laterButton.bottomAnchor.constraint(equalTo: mainLaterView.bottomAnchor).isActive = true
        laterButton.addSubview(underLineStack)
        underLineStack.centerXAnchor.constraint(equalTo: laterButton.centerXAnchor, constant: 0).isActive = true
        underLineStack.centerYAnchor.constraint(equalTo: laterButton.centerYAnchor, constant: 0).isActive = true
        underLineStack.addArrangedSubview(underLineLabel)
        underLineStack.addArrangedSubview(underLineView)
        underLineView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        underLineView.widthAnchor.constraint(equalTo: underLineLabel.widthAnchor).isActive = true
        underLineLabel.setContentHuggingPriority(UILayoutPriority.defaultLow, for: .horizontal)
        underLineView.setContentHuggingPriority(UILayoutPriority.required, for: .vertical)
        underLineView.setContentHuggingPriority(UILayoutPriority.required, for: .horizontal)
        underLineLabel.setContentHuggingPriority(UILayoutPriority.defaultLow, for: .vertical)
   
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //=============================================================================
    
    var mainStack: UIStackView = {
        let mainStack = UIStackView()
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        mainStack.axis = .vertical
        mainStack.spacing = 15.0
        return mainStack
    }()
    //=============================================================================
    
    var authButtonStack: UIStackView = {
        let authStack = UIStackView()
        authStack.translatesAutoresizingMaskIntoConstraints = false
        authStack.axis = .horizontal
        authStack.spacing = 10.0
        return authStack
    }()
    
    //=============================================================================
    var authLabel: UILabel  = {
        let authLabel = UILabel()
        authLabel.translatesAutoresizingMaskIntoConstraints = false
        authLabel.numberOfLines = 0
        authLabel.text = "Авторизироваться, чтобы получить" + "\n" +
        "доступ к функционалу."
        authLabel.textColor = UIColor(red: 48/255.0, green: 48/255.0, blue: 51/255.0, alpha: 1.0)
        authLabel.font = UIFont(name: "SFProDisplay-Semibold", size: 13)
        return authLabel
    }()
    
    //=============================================================================
    
    var fbButton: UIButton = {
        let fbButton = UIButton()
        fbButton.translatesAutoresizingMaskIntoConstraints = false
        fbButton.backgroundColor = UIColor(red: 0.0, green: CGFloat(91/255), blue: CGFloat(234/255), alpha: 1.0)
        fbButton.layer.cornerRadius = 10
        fbButton.titleLabel?.font = UIFont(name: "SFProDisplay-Bold", size: 17)
        fbButton.titleLabel?.textColor = .white
        fbButton.backgroundColor = UIColor(red: 0.0, green: 91/255.0, blue: 234/255.0, alpha: 1.0)
        fbButton.layer.cornerRadius = 10
        fbButton.layer.shadowColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.2).cgColor
        fbButton.layer.shadowOffset = CGSize(width: 0, height: 3)
        fbButton.layer.shadowOpacity  = 17
        fbButton.setTitle("Facebook", for: .normal)
        fbButton.addTarget(self, action: #selector(loginFB), for: .touchUpInside)
        return fbButton
    }()
  //==============================================================================
    
    var mainLaterView: UIView = {
        let mainLaterView = UIView()
        mainLaterView.translatesAutoresizingMaskIntoConstraints = false
        mainLaterView.backgroundColor = .clear
        return mainLaterView
    }()
    
//================================================================================
    
    var laterButton: UIButton = {
        let laterButton = UIButton()
        laterButton.translatesAutoresizingMaskIntoConstraints = false
       laterButton.contentEdgeInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0 )
        laterButton.sizeToFit()
        laterButton.addTarget(self, action: #selector(removeView), for: .touchUpInside)
        return laterButton
    }()
    
//==============================================================================
    
    var underLineStack: UIStackView = {
        let underLineStack = UIStackView()
        underLineStack.translatesAutoresizingMaskIntoConstraints = false
        underLineStack.axis = .vertical
        underLineStack.spacing = 1.0
        underLineStack.alignment = .center
        return underLineStack
    }()
    
//==============================================================================
    var underLineLabel: UILabel  = {
        let underLineLabel = UILabel()
        underLineLabel.translatesAutoresizingMaskIntoConstraints = false
        underLineLabel.numberOfLines = 0
        underLineLabel.text = "Позже"
        underLineLabel.textColor = UIColor(red: 157/255.0, green: 157 / 255.0, blue: 159/255.0, alpha: 1.0)
        underLineLabel.font = UIFont(name: "SFProText-Regular", size: 13)
        return underLineLabel
    }()
    
    var underLineView: UIView = {
        let underLineView = UIView()
        underLineView.translatesAutoresizingMaskIntoConstraints = false
        underLineView.backgroundColor =  UIColor(red: 157/255.0, green: 157 / 255.0, blue: 159/255.0, alpha: 1.0)
        return underLineView
    }()
   
    @objc func loginFB() {
        completionToVC?()
    }
    
    @objc func removeView() {
        presentAuthorizationView(view: self, hidden: false)
    }
    func presentAuthorizationView(view: UIView, hidden: Bool) {
        UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
            view.alpha = hidden ? 1: 0
        })
    }
    override func draw(_ rect: CGRect) {
        
        let cgContext = UIGraphicsGetCurrentContext()
        cgContext?.move(to: CGPoint(x: rect.minX, y: rect.minY))
        cgContext?.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        cgContext?.setStrokeColor(UIColor.lightGray.cgColor)
        cgContext?.setLineWidth(2.0)
        cgContext?.strokePath()
    }
}
