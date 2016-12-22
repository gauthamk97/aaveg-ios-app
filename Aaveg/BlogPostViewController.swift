//
//  BlogPostViewController.swift
//  Aaveg
//
//  Created by Gautham Kumar on 13/12/16.
//  Copyright © 2016 Gautham Kumar. All rights reserved.
//

import UIKit

class BlogPostViewController: UIViewController {
    
    
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var blogTitle: UILabel!
    @IBOutlet weak var blogSubtitle: UILabel!
    @IBOutlet weak var blogContentTextView: UITextView!
    @IBOutlet weak var authorNameLabel: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var authorImage: UIImageView!
    @IBOutlet weak var authorImageTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var authorImageBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var aboutAuthorText: UITextView!
    @IBOutlet weak var authorView: UIView!
    
    @IBOutlet weak var loadingActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var imageLoadingActivityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Design of View
        blogTitle.font = UIFont(name: "PingFangTC-Regular", size: 24)
        blogSubtitle.font = UIFont(name: "PingFangTC-Light", size: 16)
        
        //Checking for size of About the author page
        //checkAboutAuthorSize()
        
        //Setting status bar to white
        UIApplication.shared.statusBarStyle = .lightContent
        
        //Prevents gap at top of scroll view
        self.automaticallyAdjustsScrollViewInsets = false
        
        //Makes author icon circular
        authorImage.layer.cornerRadius = authorImage.frame.width/2
        
        //Checking if image is present
        if selectedBlogCard.isImagePresent {
            self.coverImageView.image = selectedBlogCard.coverImage.image
            imageLoadingActivityIndicator.isHidden = true
            imageLoadingActivityIndicator.stopAnimating()
        }
        
        else {
            self.setImage()
            imageLoadingActivityIndicator.isHidden = false
            imageLoadingActivityIndicator.startAnimating()
        }
        
        //Initializing activity indicator
        loadingActivityIndicator.backgroundColor = blogPageBackgroundColor
        loadingActivityIndicator.isHidden = false
        loadingActivityIndicator.startAnimating()
    
        //Setting content
        setContent()
        
        //Setting color of navbar items to white (Back Button)
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkAboutAuthorSize() {
        if authorImage.frame.height < aboutAuthorText.frame.height {
            authorView.removeConstraints([authorImageTopConstraint, authorImageBottomConstraint])
            
            //let topConstraint = NSLayoutConstraint(item: self.aboutAuthorText, attribute: .top, relatedBy: .equal, toItem: <#T##Any?#>, attribute: <#T##NSLayoutAttribute#>, multiplier: <#T##CGFloat#>, constant: <#T##CGFloat#>)
        }
    }
    
    func setContent() {
        
        let urlToHit = URL(string: "https://aaveg.net/blog/getBlogById")
        var request = URLRequest(url: urlToHit!)
        request.httpMethod = "POST"
        let paramsString = "blog_id=\(selectedBlogCard.cardID!)&only_image=no"
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
                    
                    let message = json["message"] as! [String:Any]
                    let authorname = message["author_name"] as! String
                    let title = message["title"] as! String
                    let subtitle = message["subtitle"] as! String
                    let content = message["content"] as! String
                    let realcontent = content.html2String.replacingOccurrences(of: "\n", with: "\n\n")
                    
                    DispatchQueue.main.async {
                        self.blogTitle.text = title
                        self.blogSubtitle.text = subtitle
                        self.blogContentTextView.text = realcontent
                        self.authorNameLabel.text = authorname
                        self.loadingActivityIndicator.isHidden = true
                        self.loadingActivityIndicator.stopAnimating()
                    }
                    
                }
            }
        }
        
        task.resume()

    }
    
    func setImage() {
        
        let urlToHit = URL(string: "https://aaveg.net/blog/getBlogById")
        var request = URLRequest(url: urlToHit!)
        request.httpMethod = "POST"
        let paramsString = "blog_id=\(selectedBlogCard.cardID!)&only_image=yes"
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
                    
                    let message = json["message"] as! [String:Any]
                    let image_path = message["image_path"] as! String
                    let index1 = image_path.index(image_path.startIndex, offsetBy: 22)
                    let properEncode = image_path.substring(from: index1)
                    let imageData = NSData(base64Encoded: properEncode, options: NSData.Base64DecodingOptions.init(rawValue: 0))
                    
                    if (imageData == nil) {
                        print("error in base64 conversion")
                        return
                    }
                    
                    DispatchQueue.main.async {
                        self.coverImageView.image = UIImage(data: imageData as! Data)
                        self.imageLoadingActivityIndicator.isHidden = true
                        self.imageLoadingActivityIndicator.stopAnimating()
                    }
                    
                }
            }
        }
        
        task.resume()
    }

    @IBAction func onClickRefresh(_ sender: AnyObject) {
        
        DispatchQueue.main.async {
            self.loadingActivityIndicator.isHidden = false
            self.loadingActivityIndicator.startAnimating()
            
            self.coverImageView.image = nil
            self.imageLoadingActivityIndicator.isHidden = false
            self.imageLoadingActivityIndicator.startAnimating()
            
            //Scrolls to top
            self.scrollView.contentOffset.y = 0
        }
        
        self.setContent()
        self.setImage()
        
    }
}

extension String {
    var html2String:String {
        do {
            return try NSAttributedString(data: data(using: String.Encoding.utf8)!, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil).string
        }
        catch {
            return "Error in Decoding Content. Please view on website."
        }
        
    }
}
