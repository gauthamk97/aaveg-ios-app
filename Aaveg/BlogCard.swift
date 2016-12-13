//
//  BlogCard.swift
//  Aaveg
//
//  Created by Farina Balkish A on 13/12/16.
//  Copyright © 2016 Gautham Kumar. All rights reserved.
//

import UIKit
import Foundation

class BlogCard: UIView {
    
    var coverImage = UIImageView(frame: CGRect(x: 0, y: 0, width: imageWidth, height: imageHeight))
    var titleLabel = UILabel(frame: CGRect(x: 0, y: imageHeight, width: titleWidth, height: titleHeight))
    var authorLabel = UILabel(frame: CGRect(x: 0, y: imageHeight+titleHeight, width: authorWidth, height: authorHeight))
    var clickButton = UIButton(frame: CGRect(x: 0, y: 0, width: cardWidth, height: cardHeight))
    var cardID: Int!
    
    init(yPosition: CGFloat, id: Int) {
        super.init(frame: CGRect(x: cardXOffset, y: yPosition, width: screensize.width-(2*cardXOffset), height: cardHeight))
        
        self.backgroundColor = UIColor.blue
        
        coverImage.backgroundColor = UIColor.red
        titleLabel.text = "This is title"
        authorLabel.text = "This is author"
        clickButton.backgroundColor = UIColor.clear
        clickButton.titleLabel?.text = ""
        clickButton.addTarget(self, action: #selector(self.cardSelected), for: UIControlEvents.touchUpInside)
        cardID = id
        
        self.addSubview(coverImage)
        self.addSubview(titleLabel)
        self.addSubview(authorLabel)
        self.addSubview(clickButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func cardSelected() {
        print("\(cardID!) card selected")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "cardSelected"), object: nil)
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
