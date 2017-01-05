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
    
    var coverImage = UIImageView(frame: CGRect(x: 0, y: 0, width: imageCardWidth, height: 10))
    var titleLabel = UILabel(frame: CGRect(x: 0, y: imageCardHeight, width: titleCardWidth, height: titleCardHeight))
    var authorLabel = UILabel(frame: CGRect(x: 0, y: imageCardHeight+titleCardHeight, width: authorCardWidth, height: authorCardHeight))
    var clickButton = UIButton(frame: CGRect(x: 0, y: 0, width: cardWidth, height: cardHeight))
    var cardID: Int!
    var allConstraints: [String:NSLayoutConstraint] = [:]
    
    
    init(id: Int, title: String, author: String) {
        
        super.init(frame: CGRect(x: cardXOffset, y: 0, width: cardWidth, height: cardHeight))
        
        self.backgroundColor = UIColor.white
        
        //Setting properties of the card
        cardID = id
        titleLabel.text = title
        authorLabel.text = author
        
        //Cover Image Constraints
        coverImage.backgroundColor = UIColor.lightGray
        coverImage.contentMode = .scaleAspectFill
        coverImage.clipsToBounds = true
        self.addSubview(coverImage)
        
        let imageLeftConstraint = NSLayoutConstraint(item: coverImage, attribute: .leading, relatedBy: .equal, toItem: coverImage.superview, attribute: .leading, multiplier: 1, constant: 0)
        let imageRightConstraint = NSLayoutConstraint(item: coverImage, attribute: .trailing, relatedBy: .equal, toItem: coverImage.superview, attribute: .trailing, multiplier: 1, constant: 0)
        let imageTopConstraint = NSLayoutConstraint(item: coverImage, attribute: .top, relatedBy: .equal, toItem: coverImage.superview, attribute: .top, multiplier: 1, constant: 0)
        let imageAspectRatioConstraint = NSLayoutConstraint(item: coverImage, attribute: .height, relatedBy: .equal, toItem: coverImage, attribute: .width, multiplier: imageAspectRatio, constant: 0)
        
        coverImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([imageLeftConstraint, imageRightConstraint, imageTopConstraint, imageAspectRatioConstraint])
        
        //Title Label Constraints
        self.addSubview(titleLabel)
        titleLabel.backgroundColor = UIColor.clear
        
        let titleLeftConstraint = NSLayoutConstraint(item: titleLabel, attribute: .leading, relatedBy: .equal, toItem: titleLabel.superview, attribute: .leading, multiplier: 1, constant: 7)
        let titleRightConstraint = NSLayoutConstraint(item: titleLabel, attribute: .trailing, relatedBy: .equal, toItem: titleLabel.superview, attribute: .trailing, multiplier: 1, constant: -7)
        let titleTopConstraint = NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: coverImage, attribute: .bottom, multiplier: 1, constant: 0)
        let titleHeightConstraint = NSLayoutConstraint(item: titleLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40)
        
        titleLabel.font = UIFont(name: "PingFangTC-Light", size: 20)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.numberOfLines = 2
        NSLayoutConstraint.activate([titleLeftConstraint, titleRightConstraint, titleTopConstraint, titleHeightConstraint])
        
        //Author Label Constraints
        self.addSubview(authorLabel)
        authorLabel.backgroundColor = UIColor.clear
        authorLabel.textAlignment = .left
        
        let authorLeftConstraint = NSLayoutConstraint(item: authorLabel, attribute: .leading, relatedBy: .equal, toItem: authorLabel.superview, attribute: .leading, multiplier: 1, constant: 7)
        let authorRightConstraint = NSLayoutConstraint(item: authorLabel, attribute: .trailing, relatedBy: .equal, toItem: authorLabel.superview, attribute: .trailing, multiplier: 1, constant: -7)
        let authorTopConstraint = NSLayoutConstraint(item: authorLabel, attribute: .top, relatedBy: .equal, toItem: titleLabel, attribute: .bottom, multiplier: 1, constant: -5)
        let authorHeightConstraint = NSLayoutConstraint(item: authorLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 25)
        let limitconstraint = NSLayoutConstraint(item: authorLabel, attribute: .bottom, relatedBy: .equal, toItem: authorLabel.superview, attribute: .bottom, multiplier: 1, constant: 0)
        
        authorLabel.font = UIFont(name: "PingFangSC-Thin", size: 14)
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([authorLeftConstraint, authorRightConstraint, authorTopConstraint, authorHeightConstraint, limitconstraint])
        
        //Click Button Constraints
        
        clickButton.backgroundColor = UIColor.clear
        clickButton.titleLabel?.text = ""
        clickButton.addTarget(self, action: #selector(self.cardSelected), for: UIControlEvents.touchUpInside)
        self.addSubview(clickButton)
 
        let buttonLeftConstraint = NSLayoutConstraint(item: clickButton, attribute: .leading, relatedBy: .equal, toItem: clickButton.superview, attribute: .leading, multiplier: 1, constant: 0)
        let buttonRightConstraint = NSLayoutConstraint(item: clickButton, attribute: .trailing, relatedBy: .equal, toItem: clickButton.superview, attribute: .trailing, multiplier: 1, constant: 0)
        let buttonTopConstraint = NSLayoutConstraint(item: clickButton, attribute: .top, relatedBy: .equal, toItem: clickButton.superview, attribute: .top, multiplier: 1, constant: 0)
        let buttonBottomConstraint = NSLayoutConstraint(item: clickButton, attribute: .bottom, relatedBy: .equal, toItem: clickButton.superview, attribute: .bottom, multiplier: 1, constant: 0)
        
        clickButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([buttonLeftConstraint, buttonRightConstraint, buttonTopConstraint, buttonBottomConstraint])
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func cardSelected() {
        print("\(cardID!) card selected")
        selectedBlogCard = self
        selectedBlogID = self.cardID
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "cardSelected"), object: nil)
    }
    
    func setConstraints() {
        
        let leftconstraint = NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: self.superview, attribute: .leading, multiplier: 1, constant: 15)
        let rightconstraint = NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: self.superview, attribute: .trailing, multiplier: 1, constant: 15)
        let topconstraint = NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: self.superview, attribute: .top, multiplier: 1, constant: 10)
        let centerXconstraint = NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: self.superview, attribute: .centerX, multiplier: 1, constant: 0)
        
        self.allConstraints["leftconstraint"] = leftconstraint
        self.allConstraints["rightconstraint"] = rightconstraint
        self.allConstraints["topconstraint"] = topconstraint
        self.allConstraints["centerXconstraint"] = centerXconstraint
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([leftconstraint, rightconstraint, topconstraint, centerXconstraint])
        
    }
    
    func setImage(Image64Encode: String) {
        
        let index1 = Image64Encode.range(of: "base64,")?.upperBound
        
        if (index1 == nil) {
            print("base64, not present in image_path")
            return
        }
        
        let properEncode = Image64Encode.substring(from: index1!)
        let imageData = NSData(base64Encoded: properEncode, options: NSData.Base64DecodingOptions.init(rawValue: 0))
        
        if (imageData == nil) {
            print("error in base64 conversion - \(cardID)\n")
            return
        }
        
        self.coverImage.image = UIImage(data: imageData as! Data)
        blogPosts[self.cardID]?["isImagePresent"] = true
        blogPosts[self.cardID]?["image_path"] = Image64Encode

    }
    
    func getImageForCard() {
        
        if (blogPosts[self.cardID]?["isImagePresent"] as! Bool) == true {
            setImage(Image64Encode: blogPosts[self.cardID]?["image_path"] as! String)
        }
        
        print("Getting image for card \(cardID)")
        let ID: Int = cardID
        let urlToHit = URL(string: "https://aaveg.net/blog/getBlogById")
        var request = URLRequest(url: urlToHit!)
        request.httpMethod = "POST"
        let paramsString = "blog_id=\(ID)&only_image=yes"
        request.httpBody = paramsString.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            let httpStatus = response as? HTTPURLResponse
            
            if error != nil {
                if httpStatus?.statusCode == nil {
                    print("no internet")
                }
                    
                else {
                    print("Error : \(error)")
                }
                return
            }
                
            else if httpStatus?.statusCode != 200 {
                print("Status code not 200. It is \(httpStatus?.statusCode)")
                return
            }
                
            else {
                let responseString = String(data: data!, encoding: .utf8)
                let jsonData = responseString?.data(using: .utf8)
                if let json = try? JSONSerialization.jsonObject(with: jsonData!) as! [String: Any] {
                    
                    if (json["status_code"] as! Int) != 200 {
                        print("Status code : \(json["status_code"])")
                        return
                    }
                    
                    let message = json["message"] as! [String: Any]
                    let imagePath = message["image_path"] as! String
                    DispatchQueue.main.async {
                        self.setImage(Image64Encode: imagePath)
                    }
        
                }
            }
        }
        
        task.resume()
    }


}
