//
//  UpdateTile.swift
//  Aaveg
//
//  Created by Gautham Kumar on 08/01/17.
//  Copyright © 2017 Gautham Kumar. All rights reserved.
//

import UIKit

class UpdateTile: UIView {

    var eventName = UILabel()
    var firstLabel = UILabel()
    var secondLabel = UILabel()
    var thirdLabel = UILabel()
    var firstPlace = UILabel()
    var secondPlace = UILabel()
    var thirdPlace = UILabel()
    
    var theTopConstraint = NSLayoutConstraint()
    var theBottomConstraint = NSLayoutConstraint()
    
    init(name: String, first: String, second: String, third: String) {
        
        super.init(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        
        self.backgroundColor = updateTileBaseColor
        
        //Border
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1
        
        //Setting up eventNameLabel
        eventName.translatesAutoresizingMaskIntoConstraints = false
        eventName.text = name
        eventName.textAlignment = .center
        eventName.textColor = UIColor.white
        if #available(iOS 8.2, *) {
            eventName.font = UIFont.systemFont(ofSize: 21, weight: UIFontWeightSemibold)
        } else {
            eventName.font = UIFont.boldSystemFont(ofSize: 21)
        }

        
        self.addSubview(eventName)
        
        let eventleftConstraint = NSLayoutConstraint(item: eventName, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
        let eventrightConstraint = NSLayoutConstraint(item: eventName, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
        let eventtopConstraint = NSLayoutConstraint(item: eventName, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 8)
        
        NSLayoutConstraint.activate([eventleftConstraint, eventrightConstraint, eventtopConstraint])
        
        //Setting up first label
        firstLabel.translatesAutoresizingMaskIntoConstraints = false
        firstLabel.text = "First"
        firstLabel.textColor = firstPlaceGoldColor
        firstLabel.textAlignment = .center
        if #available(iOS 8.2, *) {
            firstLabel.font = UIFont.systemFont(ofSize: 18, weight: UIFontWeightSemibold)
        } else {
            firstLabel.font = UIFont.boldSystemFont(ofSize: 18)
        }

        
        self.addSubview(firstLabel)
        
        let firstTopConstraint = NSLayoutConstraint(item: firstLabel, attribute: .top, relatedBy: .equal, toItem: eventName, attribute: .bottom, multiplier: 1, constant: 20)
        let firstLeftConstraint = NSLayoutConstraint(item: firstLabel, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
        
        NSLayoutConstraint.activate([firstTopConstraint, firstLeftConstraint])
        
        //Setting up second label
        secondLabel.translatesAutoresizingMaskIntoConstraints = false
        secondLabel.text = "Second"
        secondLabel.textColor = secondPlaceSilverColor
        secondLabel.textAlignment = .center
        if #available(iOS 8.2, *) {
            secondLabel.font = UIFont.systemFont(ofSize: 18, weight: UIFontWeightSemibold)
        } else {
            secondLabel.font = UIFont.boldSystemFont(ofSize: 18)
        }

        
        self.addSubview(secondLabel)
        
        let secondYConstraint = NSLayoutConstraint(item: secondLabel, attribute: .centerY, relatedBy: .equal, toItem: firstLabel, attribute: .centerY, multiplier: 1, constant: 0)
        let secondWidthConstraint = NSLayoutConstraint(item: secondLabel, attribute: .width, relatedBy: .equal, toItem: firstLabel, attribute: .width, multiplier: 1, constant: 0)
        let secondLeftConstraint = NSLayoutConstraint(item: secondLabel, attribute: .leading, relatedBy: .equal, toItem: firstLabel, attribute: .trailing, multiplier: 1, constant: 0)
        
        NSLayoutConstraint.activate([secondYConstraint, secondWidthConstraint, secondLeftConstraint])
        
        //Setting up third label
        thirdLabel.translatesAutoresizingMaskIntoConstraints = false
        thirdLabel.text = "Third"
        thirdLabel.textColor = thirdPlaceBronzeColor
        thirdLabel.textAlignment = .center
        
        if #available(iOS 8.2, *) {
            thirdLabel.font = UIFont.systemFont(ofSize: 18, weight: UIFontWeightSemibold)
        } else {
            thirdLabel.font = UIFont.boldSystemFont(ofSize: 18)
        }

        
        self.addSubview(thirdLabel)
        
        let thirdYConstraint = NSLayoutConstraint(item: thirdLabel, attribute: .centerY, relatedBy: .equal, toItem: firstLabel, attribute: .centerY, multiplier: 1, constant: 0)
        let thirdWidthConstraint = NSLayoutConstraint(item: thirdLabel, attribute: .width, relatedBy: .equal, toItem: firstLabel, attribute: .width, multiplier: 1, constant: 0)
        let thirdLeftConstraint = NSLayoutConstraint(item: thirdLabel, attribute: .leading, relatedBy: .equal, toItem: secondLabel, attribute: .trailing, multiplier: 1, constant: 0)
        let thirdRightConstraint = NSLayoutConstraint(item: thirdLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
        
        NSLayoutConstraint.activate([thirdYConstraint, thirdLeftConstraint, thirdWidthConstraint, thirdRightConstraint])
        
        //Setting up first place label
        firstPlace.translatesAutoresizingMaskIntoConstraints = false
        firstPlace.text = first
        firstPlace.textColor = UIColor.white
        firstPlace.textAlignment = .center
        firstPlace.font = UIFont(name: firstPlace.font.fontName, size: 17)
        firstPlace.numberOfLines = 2
        
        self.addSubview(firstPlace)
        
        let firstPlaceTopConstraint = NSLayoutConstraint(item: firstPlace, attribute: .top, relatedBy: .equal, toItem: firstLabel, attribute: .bottom, multiplier: 1, constant: 10)
        let firstPlaceLeftConstraint = NSLayoutConstraint(item: firstPlace, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
        
        NSLayoutConstraint.activate([firstPlaceTopConstraint, firstPlaceLeftConstraint])
        
        //Setting up second place label
        secondPlace.translatesAutoresizingMaskIntoConstraints = false
        secondPlace.text = second
        secondPlace.textColor = UIColor.white
        secondPlace.textAlignment = .center
        secondPlace.font = UIFont(name: secondPlace.font.fontName, size: 17)
        secondPlace.numberOfLines = 2
        
        self.addSubview(secondPlace)
        
        let secondPlaceYConstraint = NSLayoutConstraint(item: secondPlace, attribute: .centerY, relatedBy: .equal, toItem: firstPlace, attribute: .centerY, multiplier: 1, constant: 0)
        let secondPlaceWidthConstraint = NSLayoutConstraint(item: secondPlace, attribute: .width, relatedBy: .equal, toItem: firstPlace, attribute: .width, multiplier: 1, constant: 0)
        let secondPlaceLeftConstraint = NSLayoutConstraint(item: secondPlace, attribute: .leading, relatedBy: .equal, toItem: firstPlace, attribute: .trailing, multiplier: 1, constant: 0)
        
        NSLayoutConstraint.activate([secondPlaceYConstraint, secondPlaceWidthConstraint, secondPlaceLeftConstraint])
        
        //Setting up third label
        thirdPlace.translatesAutoresizingMaskIntoConstraints = false
        thirdPlace.text = third
        thirdPlace.textColor = UIColor.white
        thirdPlace.textAlignment = .center
        thirdPlace.font = UIFont(name: thirdPlace.font.fontName, size: 17)
        thirdPlace.numberOfLines = 2
        
        self.addSubview(thirdPlace)
        
        let thirdPlaceYConstraint = NSLayoutConstraint(item: thirdPlace, attribute: .centerY, relatedBy: .equal, toItem: firstPlace, attribute: .centerY, multiplier: 1, constant: 0)
        let thirdPlaceWidthConstraint = NSLayoutConstraint(item: thirdPlace, attribute: .width, relatedBy: .equal, toItem: firstPlace, attribute: .width, multiplier: 1, constant: 0)
        let thirdPlaceLeftConstraint = NSLayoutConstraint(item: thirdPlace, attribute: .leading, relatedBy: .equal, toItem: secondPlace, attribute: .trailing, multiplier: 1, constant: 0)
        let thirdPlaceRightConstraint = NSLayoutConstraint(item: thirdPlace, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
        let thirdPlaceBottomConstraint = NSLayoutConstraint(item: thirdPlace, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -10)
        
        NSLayoutConstraint.activate([thirdPlaceYConstraint, thirdPlaceLeftConstraint, thirdPlaceWidthConstraint, thirdPlaceRightConstraint, thirdPlaceBottomConstraint])

    }
    
    func setConstraints() {
    
        let leftconstraint = NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: self.superview, attribute: .leading, multiplier: 1, constant: 15)
        let rightconstraint = NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: self.superview, attribute: .trailing, multiplier: 1, constant: 15)
        let topconstraint = NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: self.superview, attribute: .top, multiplier: 1, constant: 10)
        let centerXconstraint = NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: self.superview, attribute: .centerX, multiplier: 1, constant: 0)
        let bottomconstraint = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: self.superview, attribute: .bottom, multiplier: 1, constant: -10)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([leftconstraint, rightconstraint, topconstraint, centerXconstraint, bottomconstraint])
        
        theTopConstraint = topconstraint
        theBottomConstraint = bottomconstraint
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
