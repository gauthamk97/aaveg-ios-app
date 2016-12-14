//
//  BlogCard.swift
//  Aaveg
//
//  Created by Gautham Kumar on 13/12/16.
//  Copyright © 2016 Gautham Kumar. All rights reserved.
//

import UIKit
import Foundation

class BlogCard: UIView {
    
    var coverImage = UIImageView(frame: CGRect(x: 0, y: 0, width: imageCardWidth, height: imageCardHeight))
    var titleLabel = UILabel(frame: CGRect(x: 0, y: imageCardHeight, width: titleCardWidth, height: titleCardHeight))
    var authorLabel = UILabel(frame: CGRect(x: 0, y: imageCardHeight+titleCardHeight, width: authorCardWidth, height: authorCardHeight))
    var clickButton = UIButton(frame: CGRect(x: 0, y: 0, width: cardWidth, height: cardHeight))
    var cardID: Int!
    
    init(yPosition: CGFloat, id: Int) {
        
        super.init(frame: CGRect(x: cardXOffset, y: yPosition, width: cardWidth, height: cardHeight))
        
        self.backgroundColor = UIColor.blue
        
        coverImage.backgroundColor = UIColor.red
        coverImage.contentMode = .scaleAspectFill
        titleLabel.text = "This is title"
        authorLabel.text = "This is author"
        clickButton.backgroundColor = UIColor.clear
        clickButton.titleLabel?.text = ""
        clickButton.addTarget(self, action: #selector(self.cardSelected), for: UIControlEvents.touchUpInside)
        cardID = id
        
//        self.addSubview(coverImage)
//        self.addSubview(titleLabel)
//        self.addSubview(authorLabel)
//        self.addSubview(clickButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func cardSelected() {
        print("\(cardID!) card selected")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "cardSelected"), object: nil)
    }
    
    func setConstraints() {
        let leftconstraint = NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: self.superview, attribute: .leading, multiplier: 1, constant: 5)
        let rightconstraint = NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: self.superview, attribute: .trailing, multiplier: 1, constant: 5)
        let heightconstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 100)
        let topconstraint = NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: self.superview, attribute: .top, multiplier: 1, constant: 10)
        
        NSLayoutConstraint.activate([leftconstraint, rightconstraint, heightconstraint, topconstraint])
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
