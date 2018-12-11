//
//  PostCellModel.swift
//  MaintainMyCity
//
//  Created by swstation on 9/20/18.
//  Copyright © 2018 swstation. All rights reserved.
//

import Foundation
import UIKit

struct PostCellModel {
    let fotoProfile: URL?
    let author: String
    let category: String?
    let address: String?
    let description: NSMutableAttributedString?
    let createdAt: Date
    var attachments: URL?
    let liked: Bool
    let likes: String
    let type: String
    let attributtedString: NSMutableAttributedString
    var stateBottonLike: Bool
    var stateExpandedCellPost: StateExpandedCell
    let differentTimeString: String

    static func statusString(nameAttributes: NSAttributedString, statusAttributes: NSAttributedString, scoreAttributes: NSAttributedString) -> NSMutableAttributedString {
        
        let attStr = NSMutableAttributedString(attributedString: nameAttributes)
        attStr.append(statusAttributes)
        attStr.append(scoreAttributes)
        
        return attStr
    }
    static func spacingBetweenStrings(_ string: String) -> NSMutableAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 3.0
        let attrString = NSMutableAttributedString(string: string)
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
        return attrString
        
    }

    init?(_ post: PostInfoMO, _ state: Bool, _ expanded: StateExpandedCell) {
        guard let authorName = post.author?.name, let categoryMO = post.category, let dateMO = post.createdAt, let fotoMO = post.author?.avatarUrl  else {
            return nil
            
        }
        let foto = URL(string: fotoMO)
        let data = dateMO as Date
        var images: AssetsMO = AssetsMO()
        for asset in post.assets! {
            images = (asset as? AssetsMO)!
         }
        attachments = URL(string: (images.thumbnail)!)
        author = authorName
        category = categoryMO.title
        address = post.address
        description = PostCellModel.spacingBetweenStrings(post.postDescription!)
        createdAt = data
      
        liked = post.liked
        likes = "\(post.likes)"
        type = post.type!
        fotoProfile = foto
        let nameAtt = NSAttributedString(string: authorName, attributes: [ .foregroundColor: UIColor(red: 25 / 255.0, green: 135 / 255.0, blue: 255 / 255.0, alpha: 1.0), .font: UIFont(name: "SFProDisplay-Semibold", size: 13.5)!])
        
        let statusAtt = NSAttributedString(string: " отправил заявку ", attributes: [ .foregroundColor: UIColor.black, .font: UIFont(name: "SF Pro Text", size: 13.5)!])
        
        let scoreAtt = NSAttributedString(string: "+20", attributes: [ .foregroundColor: UIColor.red, .font: UIFont(name: "SFProDisplay-Bold", size: 8.0)!])
        
        attributtedString = PostCellModel.statusString(nameAttributes: nameAtt, statusAttributes: statusAtt, scoreAttributes: scoreAtt)
        stateBottonLike = state
        stateExpandedCellPost = expanded
        let creatDiffTime = String()
        if let timeStr = creatDiffTime.getDiffTime(olderDate: (data), newerDate: Date()) {
            differentTimeString = timeStr + " назад"
        } else {
            differentTimeString = ""
        }
    }
    
}
