//
//  CustomNavigationBar.swift
//  MaintainMyCity
//
//  Created by swstation on 03.10.2018.
//  Copyright © 2018 swstation. All rights reserved.
//

import UIKit

class CustomNavigationBar: UINavigationBar {
    
    enum NavBarType {
        case newRequest
        case profile
    }

    let titleLabel = UILabel()
    var leadingConstraint: NSLayoutConstraint?
    var bottomConstraint: NSLayoutConstraint?
    private var subtitleHeight: CGFloat = 0.0
    var progressView = UIProgressView()
    var progressLabel = UILabel()
    var type: NavBarType = .newRequest
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        let frameHeight = max(min(frame.height, 96.0), 44.0)
        
        let offsetProportion = (frameHeight - 44.0) / (96.0 - 44.0)
        
        let offset = -200 + offsetProportion * 200 + 15.0
        let yOffset = offsetProportion * subtitleHeight
        
        leadingConstraint?.constant = offset
        bottomConstraint?.constant = yOffset
        
        UIView.animate(withDuration: 0.03, delay: 0.0, options: [ .curveEaseInOut, .beginFromCurrentState ], animations: {
            self.layoutIfNeeded()
        }, completion: nil)
    }
    
    private func commonInit() {
        
        addObserver(self, forKeyPath: "frame", options: [.initial, .new], context: nil)
        prefersLargeTitles = true
        isTranslucent = false
        backgroundColor = .white
        shadowImage = UIImage()
        barTintColor = .white
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.trackTintColor = .white
        progressView.progress = 0.0
        addSubview(progressView)
        
        updateProgress(0.0)
        progressLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(progressLabel)
        let font = UIFont.preferredFont(forTextStyle: .largeTitle)
        var traits = font.fontDescriptor.symbolicTraits
        traits.insert(.traitBold)
        
        var targetFont: UIFont?
        
        if let boldFontDescriptor = font.fontDescriptor.withSymbolicTraits(traits) {
            targetFont = UIFont(descriptor: boldFontDescriptor, size: font.pointSize)
        }
        targetFont = targetFont ?? font
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Новая заявка"
        titleLabel.font = targetFont
        addSubview(titleLabel)
        
        progressView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: progressView.trailingAnchor).isActive = true
        bottomAnchor.constraint(equalTo: progressView.bottomAnchor).isActive = true
        
        leadingConstraint = progressLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15.0)
        leadingConstraint?.isActive = true
        progressView.topAnchor.constraint(equalTo: progressLabel.bottomAnchor, constant: 5.0).isActive = true
        
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15.0).isActive = true
        
        progressLabel.sizeToFit()
        subtitleHeight = progressLabel.bounds.height + 5.0
        
        bottomConstraint = bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: subtitleHeight)
        bottomConstraint?.isActive = true
    }
    
    class  func statusString(progressAttributes: NSAttributedString, statusAttributes: NSAttributedString) -> NSMutableAttributedString {
        
        let attStr = NSMutableAttributedString(attributedString: progressAttributes)
        attStr.append(statusAttributes)
        return attStr
    }
    
//    func updateProgress(_ value: Float) {
//        progressView.setProgress(value, animated: true)
//        let newValue =  Int(value * 100)
//
//        let progressAtt = NSAttributedString(string: "Прогресс ", attributes: [.foregroundColor: UIColor(red: 109 / 255.0, green: 109 / 255.0, blue: 114 / 255.0, alpha: 1), .font: UIFont(name: "SFProText-Regular", size: 13)!])
//        let statusAtt = NSAttributedString(string: "\(newValue) % ", attributes: [ .foregroundColor: UIColor.black, .font: UIFont(name: "SFProDisplay-Bold", size: 13)!])
//
//        progressLabel.attributedText = CustomNavigationBar.statusString(progressAttributes: progressAtt, statusAttributes: statusAtt)
//    }
    
    func setNavBar(largeTitle: String, type: NavBarType) {
        titleLabel.text = largeTitle
        self.type = type
        
    }
    
    func updateProgress(_ value: Float) {
        progressView.setProgress(value, animated: true)
        let newValue =  Int(value * 100)
        if self.type == .newRequest {
            let progressAtt = NSAttributedString(string: "Прогресс ", attributes: [.foregroundColor: UIColor(red: 109 / 255.0, green: 109 / 255.0, blue: 114 / 255.0, alpha: 1), .font: UIFont(name: "SFProText-Regular", size: 13)!])
            let statusAtt = NSAttributedString(string: "\(newValue) % ", attributes: [ .foregroundColor: UIColor.black, .font: UIFont(name: "SFProDisplay-Bold", size: 13)!])
            progressLabel.attributedText = CustomNavigationBar.statusString(progressAttributes: progressAtt, statusAttributes: statusAtt)
        } else if self.type == .profile {
            let progressAtt = NSAttributedString(string: "Рейтинг ", attributes: [.foregroundColor: UIColor(red: 109 / 255.0, green: 109 / 255.0, blue: 114 / 255.0, alpha: 1), .font: UIFont(name: "SFProText-Regular", size: 13)!])
            let statusAtt = NSAttributedString(string: "\(value) ", attributes: [ .foregroundColor: UIColor.black, .font: UIFont(name: "SFProDisplay-Bold", size: 13)!])
            
            progressLabel.attributedText = CustomNavigationBar.statusString(progressAttributes: progressAtt, statusAttributes: statusAtt)
            
        }
    }

}
