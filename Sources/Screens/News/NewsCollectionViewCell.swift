//
//  NewsCollectionViewCell.swift
//  MaintainMyCity
//
//  Created by swstation on 9/5/18.
//  Copyright © 2018 swstation. All rights reserved.
//

import UIKit

class NewsCollectionViewCell: UICollectionViewCell {
    var category: (() -> Void)?
    var like: ((Bool) -> Void)?
    
//====================================================================================
    
    var locationStackView: UIStackView = {
        let locationStackView = UIStackView()
        locationStackView.translatesAutoresizingMaskIntoConstraints = false
        locationStackView.spacing = 0
        return locationStackView
    }()
    
//=====================================================================================

    var addressLabel: UILabel = {
        let addressLabel = UILabel()
        addressLabel .lineBreakMode = .byWordWrapping
        addressLabel .textAlignment = .left
        addressLabel .numberOfLines = 0
        addressLabel .translatesAutoresizingMaskIntoConstraints = false
        addressLabel .font = UIFont(name: "SFProText-Regular", size: 15)
        addressLabel.textColor = .lightGray
        return addressLabel
    }()
    
//====================================================================================

    var pinButton: UIButton = {
        let pinButton = UIButton()
        pinButton.translatesAutoresizingMaskIntoConstraints = false
        pinButton.setImage(UIImage(named: "mapPinIcon"), for: .normal)
        return pinButton
    }()
    
//====================================================================================

    var sepView: UIView = {
        let sepView = UIView()
        sepView.translatesAutoresizingMaskIntoConstraints = false
        sepView.backgroundColor = .clear
        return sepView
    }()
    
//====================================================================================
    
    var labelDescription: UILabel = {
        let labelDescription = UILabel()
        labelDescription.lineBreakMode = .byWordWrapping
        labelDescription.textAlignment = .justified
        labelDescription.numberOfLines = 0
    
        labelDescription.translatesAutoresizingMaskIntoConstraints = false
        labelDescription.font = UIFont(name: "SFProText-Regular", size: 17)
        return labelDescription
    }()
    
//====================================================================================

     var categoryButton: UIButton = {
        let categoryButton = UIButton()
        categoryButton.translatesAutoresizingMaskIntoConstraints = false
        categoryButton.backgroundColor = UIColor(red: 70/255.0, green: 196/255.0, blue: 108/255.0, alpha: 1.0)
        categoryButton.layer.cornerRadius = 10
        categoryButton.contentEdgeInsets = UIEdgeInsets(top: 2, left: 10, bottom: 2, right: 10 )
      categoryButton.titleLabel?.font  = UIFont(name: "SF Pro Text", size: 12)
        return categoryButton
    }()
    
//====================================================================================

    var mainImageView: UIImageView = {
        let mainImageView = UIImageView()
        mainImageView.translatesAutoresizingMaskIntoConstraints = false
        mainImageView.contentMode = .scaleAspectFill
        mainImageView.clipsToBounds = true
        return mainImageView
    }()
    
//====================================================================================
   
    var userPhotoProfile: UIImageView = {
        let userPhotoProfile = UIImageView()
        userPhotoProfile.translatesAutoresizingMaskIntoConstraints = false
        userPhotoProfile.clipsToBounds = true
        return userPhotoProfile
        
    }()
    
//====================================================================================
    
    var twoLabelStackView: UIStackView  = {
        let twoLabelStackView = UIStackView()
        twoLabelStackView.translatesAutoresizingMaskIntoConstraints = false
        twoLabelStackView.axis = .vertical
        twoLabelStackView.spacing = 1.0
        twoLabelStackView.distribution = .fillProportionally
        twoLabelStackView.contentMode = .scaleAspectFill
        return twoLabelStackView
    }()
    
//====================================================================================
    
    var attributesLabel: UILabel = {
        let attributesLabel = UILabel()
        attributesLabel.numberOfLines = 0
        attributesLabel.translatesAutoresizingMaskIntoConstraints = false
        let myAttribute = [ NSMutableAttributedString.Key.font: UIFont(name: "SF Pro Text", size: 13.0)! ]
        return attributesLabel
    }()
    
//====================================================================================
    
    var diffTimeLabel: UILabel = {
        let diffTimeLabel = UILabel()
        diffTimeLabel.numberOfLines = 0
        diffTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        diffTimeLabel.font = UIFont(name: "SFProText-Regular", size: 10)
        diffTimeLabel.textColor = .lightGray
        return diffTimeLabel
    }()
    
//====================================================================================

    var stackView: UIStackView  = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
//====================================================================================

    var likeStackView: UIStackView = {
        let likeStackView = UIStackView()
        likeStackView.alignment = .center
        likeStackView.spacing = 2.0
        likeStackView.axis = .horizontal
        likeStackView.translatesAutoresizingMaskIntoConstraints = false
        return likeStackView
    }()
    
//====================================================================================

    var countLikes: UILabel = {
        let countLikes = UILabel()
        countLikes.translatesAutoresizingMaskIntoConstraints = false
        countLikes.font = UIFont(name: "SF Pro Display", size: 17.0)
        countLikes.font = UIFont.boldSystemFont(ofSize: 17)
        countLikes.textAlignment = .center
        countLikes.sizeToFit()
        return countLikes
    }()
    
//====================================================================================
  
    var heartButton: UIButton = {
        let heartButton = UIButton()
        heartButton.translatesAutoresizingMaskIntoConstraints = false
    
        heartButton.setImage(UIImage(named: "likeIconDeselected"), for: .normal)
        heartButton.setImage(UIImage(named: "likeIconSelected"), for: .selected)
        return heartButton
    }()
    
//====================================================================================

    lazy var width: NSLayoutConstraint = {
        let width = contentView.widthAnchor.constraint(equalToConstant: bounds.size.width)
        width.isActive = true
        return width
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        setupView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        width.constant = bounds.size.width
        return contentView.systemLayoutSizeFitting(CGSize(width: targetSize.width, height: 1))
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        setupUI()
    }
    
    var stackViewTopAnchor: NSLayoutConstraint?
    
    fileprivate func setupView() {
        
        contentView.addSubview(categoryButton)
        categoryButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20).isActive = true
        categoryButton.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20).isActive = true
        contentView.addSubview(locationStackView)
        locationStackView.topAnchor.constraint(equalTo: categoryButton.bottomAnchor, constant: 10).isActive = true
        locationStackView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20).isActive = true
        locationStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        
        locationStackView.axis = .horizontal
        locationStackView.spacing = 10.0
        locationStackView.addArrangedSubview(addressLabel)
        locationStackView.addArrangedSubview(pinButton)
        pinButton.setContentHuggingPriority(UILayoutPriority.required, for: .vertical)
        pinButton.setContentHuggingPriority(UILayoutPriority.required, for: .horizontal)
        addressLabel.setContentHuggingPriority(UILayoutPriority.defaultLow, for: .horizontal)
        addressLabel.setContentHuggingPriority(UILayoutPriority.defaultLow, for: .vertical)
        contentView.addSubview(sepView)
        sepView.topAnchor.constraint(equalTo: locationStackView.bottomAnchor, constant: 0).isActive = true
        sepView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 0).isActive = true
        sepView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0).isActive = true
        sepView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        contentView.addSubview(labelDescription)
        labelDescription.topAnchor.constraint(equalTo: sepView.bottomAnchor, constant: 10).isActive = true
        labelDescription.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20).isActive = true
        labelDescription.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        
        contentView.addSubview(stackView)
        stackViewTopAnchor = stackView.topAnchor.constraint(equalTo: labelDescription.bottomAnchor, constant: 10)
        stackView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20).isActive = true
        stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15).isActive = true
         stackViewTopAnchor?.isActive = true
        stackView.axis = .horizontal
        stackView.alignment = .top
        stackView.spacing = 10.0
        stackView.addArrangedSubview(userPhotoProfile)
        stackView.addArrangedSubview(twoLabelStackView)
        
        userPhotoProfile.contentMode = .scaleAspectFit
        userPhotoProfile.heightAnchor.constraint(equalToConstant: 19).isActive = true
        userPhotoProfile.widthAnchor.constraint(equalToConstant: 19).isActive = true
        userPhotoProfile.setContentHuggingPriority(UILayoutPriority.required, for: .vertical)
        userPhotoProfile.setContentHuggingPriority(UILayoutPriority.required, for: .horizontal)
        userPhotoProfile.layer.cornerRadius = 10.0
        twoLabelStackView.setContentHuggingPriority(UILayoutPriority.defaultLow, for: .horizontal)
        twoLabelStackView.setContentHuggingPriority(UILayoutPriority.defaultLow, for: .vertical)
        twoLabelStackView.addArrangedSubview(attributesLabel)
        twoLabelStackView.addArrangedSubview(diffTimeLabel)
        
        diffTimeLabel.setContentHuggingPriority(UILayoutPriority.required, for: .vertical)
        diffTimeLabel.setContentHuggingPriority(UILayoutPriority.required, for: .horizontal)
        
        attributesLabel.setContentHuggingPriority(UILayoutPriority.defaultLow, for: .horizontal)
        attributesLabel.setContentHuggingPriority(UILayoutPriority.defaultLow, for: .vertical)
        
        contentView.addSubview(likeStackView)
        likeStackView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 10).isActive = true
        likeStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        likeStackView.axis = .horizontal
        likeStackView.spacing = 0.0
        likeStackView.addArrangedSubview(countLikes)
        likeStackView.addArrangedSubview(heartButton)
       
        heartButton.setContentHuggingPriority(UILayoutPriority.required, for: .vertical)
        heartButton.setContentHuggingPriority(UILayoutPriority.required, for: .horizontal)
        heartButton.heightAnchor.constraint(equalTo: countLikes.heightAnchor, multiplier: 1)
        heartButton.widthAnchor.constraint(equalToConstant: 44.0).isActive = true
        contentView.bottomAnchor.constraint(equalTo: likeStackView.bottomAnchor, constant: 10).isActive = true
        
    }
    
    private func setupUI() {
        layer.cornerRadius = 7
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 1.0)
        layer.shadowRadius = 4.0
        layer.shadowOpacity = 1.0
        layer.masksToBounds = false
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 10.0
        
        let path = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath
              
        layer.shadowPath = path
        
    }
    
    func showShortDescription() {
        if mainImageView.superview != nil {
        mainImageView.removeFromSuperview()
        stackViewTopAnchor?.isActive = true
        contentView.layoutIfNeeded()
        
        self.setNeedsUpdateConstraints()
        }
    }
    
    func showFullDescription() {
        if mainImageView.superview == nil {
        contentView.addSubview(mainImageView)
        stackViewTopAnchor?.isActive = false
        mainImageView.topAnchor.constraint(equalTo: labelDescription.bottomAnchor, constant: 10).isActive = true
        mainImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20).isActive = true
        mainImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        
        mainImageView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.14).isActive = true
        stackView.topAnchor.constraint(equalTo: mainImageView.bottomAnchor, constant: 10).isActive = true
        
        contentView.layoutIfNeeded()
        
        self.setNeedsUpdateConstraints()
        }
    }
    func setup(with cellModel: PostCellModel?) {
        labelDescription.attributedText = cellModel?.description
        categoryButton.setTitle(cellModel?.category?.uppercased(), for: .normal)
//        categoryButton.contentEdgeInsets = UIEdgeInsets(top: 2, left: 5, bottom: 2, right: 5)
        heartButton.isEnabled = (cellModel?.stateBottonLike)!
        heartButton.isSelected = cellModel?.liked ?? false
        
        categoryButton.sizeToFit()
        categoryButton.addTarget(self, action: #selector(viewCategory), for: .touchUpInside)
        if let `attachments` = cellModel?.attachments {
            let imageURL = attachments
            mainImageView.af_setImage(withURL: imageURL)
        }
         mainImageView.contentMode = .scaleAspectFill
        countLikes.text = cellModel?.likes
        userPhotoProfile.af_setImage(withURL: (cellModel?.fotoProfile)!)
        addressLabel.text = cellModel?.address
        
        diffTimeLabel.text = (cellModel?.differentTimeString)!
        
        attributesLabel.attributedText =  cellModel?.attributtedString
        heartButton.addTarget(self, action: #selector(setLike(sender:)), for: .touchUpInside)
        pinButton.addTarget(self, action: #selector(toMapPin), for: .touchUpInside)
        let stateExpanded = (cellModel?.stateExpandedCellPost)!
        switch stateExpanded {
        case .expanded:
            self.showFullDescription()
        case .notExpanded:
            self.showShortDescription()
        }
        
    }
    
    @objc func viewCategory() {
        
        category?()
    }
    
    @objc func toMapPin() {
        
    }
    @objc func setLike(sender: AnyObject) {

        if let button = sender as? UIButton {
            if button.isSelected {
            UIView.animate(withDuration: 0.3) {
                button.isSelected = false }
                like?(false)
            } else {
            UIView.animate(withDuration: 0.3) {
                button.isSelected = true}
                like?(true)
             }
        }
        
    }
    
}
