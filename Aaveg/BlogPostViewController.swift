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
    
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Design of View
        blogTitle.font = UIFont(name: "PingFangTC-Regular", size: 26)
        blogSubtitle.font = UIFont(name: "PingFangTC-Regular", size: 18)
        blogContentTextView.font = UIFont(name: "PingFangTC-Light", size: 16)
        aboutAuthorText.font = UIFont(name: "PingFangTC-Light", size: 14)
        
        //Setting status bar to white
        UIApplication.shared.statusBarStyle = .lightContent
        
        //Prevents gap at top of scroll view
        self.automaticallyAdjustsScrollViewInsets = false
        
        //Makes author icon circular
        authorImage.layer.cornerRadius = authorImage.frame.width/2
        
        //Checking if image is present
        if blogPosts[selectedBlogID]?["isImagePresent"] as! Bool {
            self.coverImageView.image = imageWithString(Image64Encode: blogPosts[selectedBlogID]?["image_path"] as! String)
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
        
        //Removing errorLabel at the start
        self.errorLabel.isHidden = true
        self.errorLabel.backgroundColor = blogPageBackgroundColor
        
    }

    override func viewDidAppear(_ animated: Bool) {
        //Resetting color of selected card
        selectedBlogCard.backgroundColor = UIColor.white
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        self.authorImage.layer.cornerRadius = self.authorImage.frame.width/2
    }
    
    func imageWithString(Image64Encode: String) -> UIImage? {
        
        let index1 = Image64Encode.range(of: "base64,")?.upperBound
        
        if (index1 == nil) {
            print("base64, not present in image_path")
            return nil
        }
        
        let properEncode = Image64Encode.substring(from: index1!)
        let imageData = NSData(base64Encoded: properEncode, options: NSData.Base64DecodingOptions.init(rawValue: 0))
        
        if (imageData == nil) {
            print("error in base64 conversion - \(selectedBlogID)\n")
            return nil
        }
        
        return UIImage(data: imageData as! Data)
        
    }
    
    func setContent() {
        
        if blogPosts[selectedBlogID]?["isContentPresent"] as! Bool {
            DispatchQueue.main.async {
                self.blogTitle.text = blogPosts[selectedBlogID]?["title"] as? String
                self.blogSubtitle.text = blogPosts[selectedBlogID]?["subtitle"] as? String
                self.blogContentTextView.text = blogPosts[selectedBlogID]?["content"] as! String
                self.authorNameLabel.text = blogPosts[selectedBlogID]?["author_name"] as? String
                self.setAuthorView(name: blogPosts[selectedBlogID]?["author_name"] as! String)
                self.loadingActivityIndicator.isHidden = true
                self.loadingActivityIndicator.stopAnimating()
                self.errorLabel.isHidden = true
            }
            
            return
        }
        
        
        let urlToHit = URL(string: "https://aaveg.net/blog/getBlogById")
        var request = URLRequest(url: urlToHit!)
        request.httpMethod = "POST"
        let paramsString = "blog_id=\(selectedBlogCard.cardID!)&only_image=no"
        request.httpBody = paramsString.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            let httpStatus = response as? HTTPURLResponse
            
            if error != nil {
                if httpStatus?.statusCode == nil {
                    DispatchQueue.main.async {
                        self.errorLabel.isHidden = false
                    }
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
                    var realcontent = content.html2String.replacingOccurrences(of: "\n", with: "\n\n")
                    
                    //Removing unnecessary newline at end
                    let ending = realcontent.substring(from: realcontent.index(realcontent.endIndex, offsetBy: -2))
                    if ending == "\n\n" {
                        realcontent = realcontent.substring(to: realcontent.index(realcontent.endIndex, offsetBy: -2))
                    }
                    
                    blogPosts[selectedBlogID]?["author_name"] = authorname
                    blogPosts[selectedBlogID]?["title"] = title
                    blogPosts[selectedBlogID]?["subtitle"] = subtitle
                    blogPosts[selectedBlogID]?["content"] = realcontent
                    blogPosts[selectedBlogID]?["isContentPresent"] = true
                    
                    DispatchQueue.main.async {
                        self.blogTitle.text = title
                        self.blogSubtitle.text = subtitle
                        self.blogContentTextView.text = realcontent
                        self.authorNameLabel.text = authorname
                        self.setAuthorView(name: authorname)
                        self.loadingActivityIndicator.isHidden = true
                        self.loadingActivityIndicator.stopAnimating()
                        self.errorLabel.isHidden = true
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
                    DispatchQueue.main.async {
                        self.errorLabel.isHidden = false
                    }
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
                    let index1 = image_path.range(of: "base64,")?.upperBound
                    
                    if (index1 == nil) {
                        print("base64, not present in image_path")
                        return
                    }
                    
                    let properEncode = image_path.substring(from: index1!)
                    let imageData = NSData(base64Encoded: properEncode, options: NSData.Base64DecodingOptions.init(rawValue: 0))
                    
                    if (imageData == nil) {
                        print("error in base64 conversion")
                        return
                    }
                    
                    DispatchQueue.main.async {
                        self.coverImageView.image = UIImage(data: imageData as! Data)
                        self.imageLoadingActivityIndicator.isHidden = true
                        self.imageLoadingActivityIndicator.stopAnimating()
                        self.errorLabel.isHidden = true
                    }
                    
                    blogPosts[selectedBlogID]?["isImagePresent"] = true
                    
                }
            }
        }
        
        task.resume()
    }
    
    func setAuthorView(name: String) {
        
        if name == "Avinash Tadavarthy" {
            self.aboutAuthorText.text = AvinashAboutMe
            self.authorImage.image = UIImage(named: "avinash")
        }
        
        else if name == "Kiran Krishnan" {
            self.aboutAuthorText.text = KiranAboutMe
            self.authorImage.image = UIImage(named: "kiran")
        }
        
        else if name == "Tanvi Kumar" {
            self.aboutAuthorText.text = TanviAboutMe
            self.authorImage.image = UIImage(named: "tanvi")
        }
        
        else if name == "Anirudh Banerjee" {
            self.aboutAuthorText.text = AnirudhAboutMe
            self.authorImage.image = UIImage(named: "anirudh")
        }
        
        else if name == "Mathirush S" {
            self.aboutAuthorText.text = MathirushAboutMe
            self.authorImage.image = UIImage(named: "mathirush")
        }
        
        else {
            self.aboutAuthorText.text = ContentTeamAboutMe
        }
        
    }

    @IBAction func onClickRefresh(_ sender: AnyObject) {
        
        DispatchQueue.main.async {
            self.errorLabel.isHidden = true
            
            self.loadingActivityIndicator.isHidden = false
            self.loadingActivityIndicator.startAnimating()
            
            self.coverImageView.image = nil
            self.imageLoadingActivityIndicator.isHidden = false
            self.imageLoadingActivityIndicator.startAnimating()
            
            //Scrolls to top
            self.scrollView.contentOffset.y = 0
        }
        
        blogPosts[selectedBlogID]?["isContentPresent"] = false
        blogPosts[selectedBlogID]?["isImagePresent"] = false
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
