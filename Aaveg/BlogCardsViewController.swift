//
//  BlogCardsViewController.swift
//  Aaveg
//
//  Created by Gautham Kumar on 13/12/16.
//  Copyright © 2016 Gautham Kumar. All rights reserved.
//

import UIKit

class BlogCardsViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    var blogCards: [BlogCard] = []
    var loadingMoreCardsIndicator: UIActivityIndicatorView!
    var activityHeightConstraint: NSLayoutConstraint!
    var activityTopConstraint: NSLayoutConstraint!
    
    var blogIDs: [String] = []
    var isRefreshingCards: Bool = false
    var totalNumberOfPosts: Int = 0
    
    var refreshControl = UIRefreshControl()
    
    @IBOutlet weak var noInternetLabel: UILabel!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Prevents vertical offset of scroll view
        self.automaticallyAdjustsScrollViewInsets = false
        
        //Setting scrollView Delegates
        scrollView.delegate = self
        
        //Setting up loading activity indicator
        loadingMoreCardsIndicator = UIActivityIndicatorView()
        self.scrollView.addSubview(loadingMoreCardsIndicator)
        loadingMoreCardsIndicator.color = UIColor.gray
        loadingMoreCardsIndicator.isHidden = false
        loadingMoreCardsIndicator.startAnimating()
        setActivityIndicatorConstraints()
        
        //Getting Blog IDs
        getBlogIDs()
        
        //Watching for when user selects a card
        NotificationCenter.default.addObserver(self, selector: #selector(self.cardSelected), name: NSNotification.Name(rawValue: "cardSelected"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.blogIDsRecieved), name: NSNotification.Name(rawValue: "blogIDsRecieved"), object: nil)
        
        //Setting status bar to white
        UIApplication.shared.statusBarStyle = .lightContent
        
        //Removing no internet label at first
        noInternetLabel.isHidden = true
        
        //Initializing refresh control
        refreshControl.tintColor = UIColor.gray
        refreshControl.backgroundColor = self.scrollView.backgroundColor
        refreshControl.addTarget(self, action: #selector(self.onClickRefresh(_:)), for: .valueChanged)
        self.scrollView.addSubview(refreshControl)
        
        if self.revealViewController() != nil {
            print("setting reveal view controller")
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if ((scrollView.contentOffset.y + 15 >= (scrollView.contentSize.height-scrollView.frame.size.height)) && !isRefreshingCards) {
            
            let currentNumberOfCards = blogCards.count
            
            if currentNumberOfCards==totalNumberOfPosts {
                
                self.loadingMoreCardsIndicator.removeConstraint(activityHeightConstraint)
                activityHeightConstraint = NSLayoutConstraint(item: loadingMoreCardsIndicator, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 10)
                NSLayoutConstraint.activate([activityHeightConstraint])
                
                self.loadingMoreCardsIndicator.stopAnimating()
                self.loadingMoreCardsIndicator.isHidden = true
                
            }
            
            else if ((totalNumberOfPosts-currentNumberOfCards) <= 2) {
                getCardDetails(idBegin: Int.init(blogIDs[currentNumberOfCards])!, idEnd: Int.init(blogIDs[blogIDs.count-1])!)
            }
                
            else {
                getCardDetails(idBegin: Int.init(blogIDs[currentNumberOfCards])!, idEnd: Int.init(blogIDs[currentNumberOfCards+2])!)
            }
        }
        
    }
    
    func cardSelected() {
        performSegue(withIdentifier: "toBlogView", sender: self)
    }
    
    func setActivityIndicatorConstraints() {
        
        let leftconstraint = NSLayoutConstraint(item: loadingMoreCardsIndicator, attribute: .leading, relatedBy: .equal, toItem: loadingMoreCardsIndicator.superview, attribute: .leading, multiplier: 1.0, constant: 0)
        let centreXconstraint = NSLayoutConstraint(item: loadingMoreCardsIndicator, attribute: .centerX, relatedBy: .equal, toItem: loadingMoreCardsIndicator.superview, attribute: .centerX, multiplier: 1.0, constant: 0)
        let bottomconstraint = NSLayoutConstraint(item: loadingMoreCardsIndicator, attribute: .bottom, relatedBy: .equal, toItem: loadingMoreCardsIndicator.superview, attribute: .bottom, multiplier: 1.0, constant: 0)
        activityHeightConstraint = NSLayoutConstraint(item: loadingMoreCardsIndicator, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 40)
        activityTopConstraint = NSLayoutConstraint(item: loadingMoreCardsIndicator, attribute: .top, relatedBy: .equal, toItem: loadingMoreCardsIndicator.superview, attribute: .top, multiplier: 1.0, constant: 0)
        loadingMoreCardsIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([leftconstraint, centreXconstraint, bottomconstraint, activityHeightConstraint, activityTopConstraint])
        
    }
    
    func addCard(id: Int, title: String, author: String) {
        
        let tempCard = BlogCard(id: id, title: title, author: author)
        
        //Removing activity's constraint to penultimate card
        self.scrollView.removeConstraint(activityTopConstraint)
        
        blogCards.append(tempCard)
        self.scrollView.addSubview(blogCards[blogCards.count-1])
        blogCards[blogCards.count-1].setConstraints()
        
        activityTopConstraint = NSLayoutConstraint(item: self.loadingMoreCardsIndicator, attribute: .top, relatedBy: .equal, toItem: blogCards[blogCards.count-1], attribute: .bottom, multiplier: 1.0, constant: 0)
        
        NSLayoutConstraint.activate([activityTopConstraint])
        
        //Setting the new top constraint for the final card
        if blogCards.count > 1 {
        
            self.scrollView.removeConstraint(blogCards[blogCards.count-1].allConstraints["topconstraint"]!)
            let topconstraint = NSLayoutConstraint(item: blogCards[blogCards.count-1], attribute: .top, relatedBy: .equal, toItem: blogCards[blogCards.count-2], attribute: .bottom, multiplier: 1, constant: 10)
            NSLayoutConstraint.activate([topconstraint])
            blogCards[blogCards.count-1].allConstraints["topconstraint"] = topconstraint

        }
        
        //Fetch image
        tempCard.getImageForCard()
    }

    func getBlogIDs() {
        
        let urlToHit = URL(string: "https://aaveg.net/blog/getAllBlogIds")
        var request = URLRequest(url: urlToHit!)
        request.httpMethod = "POST"
        request.httpBody = nil //Parameters to send, if needed (must be encoded)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            let httpStatus = response as? HTTPURLResponse
            
            if error != nil {
                if httpStatus?.statusCode == nil {
                    DispatchQueue.main.async {
                        self.noInternetLabel.isHidden = false
                    }
                }
                    
                else {
                    print("Error : \(error)")
                }
                return
            }
                
            else if httpStatus?.statusCode != 200 {
                print("Status code is not 200. It is \(httpStatus?.statusCode)")
                return
            }
                
            else {
                let responseString = String(data: data!, encoding: .utf8)
                let jsonData = responseString?.data(using: .utf8)
                if let json = try? JSONSerialization.jsonObject(with: jsonData!) as! [String: Any]{
                    self.blogIDs = json["message"] as! [String]
                    DispatchQueue.main.async {
                        self.noInternetLabel.isHidden = true
                    }
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "blogIDsRecieved"), object: nil)
                }
                
            }

        }
        
        task.resume()
        
    }
    
    func blogIDsRecieved() {
        print(self.blogIDs)
        totalNumberOfPosts = blogIDs.count
        let idbegin:Int = Int(blogIDs[0])!
        let idend:Int = Int(blogIDs[2])!
        print("Ids - \(idbegin) \(idend)")
        getCardDetails(idBegin: idbegin, idEnd: idend)
    }
    
    func getCardDetails(idBegin: Int, idEnd: Int) {
        
        //Setting UI elements and variables
        isRefreshingCards = true
        
        let urlToHit = URL(string: "https://aaveg.net/blog/getBlogById")
        var request = URLRequest(url: urlToHit!)
        request.httpMethod = "POST"
        let paramsString = "blog_id=\(idBegin)&blog_id_end=\(idEnd)"
        request.httpBody = paramsString.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            let httpStatus = response as? HTTPURLResponse
            
            if error != nil {
                if httpStatus?.statusCode == nil {
                    print("noo internet")
                    DispatchQueue.main.async {
                        self.noInternetLabel.isHidden = false
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
                if let json = try? JSONSerialization.jsonObject(with: jsonData!) as! [String: Any]{
                    let cardDetails = json["message"] as! [[String: Any]]
                    print("Card details - \(cardDetails)")
                    
                    for card in cardDetails {
                        let blogID = Int.init(card["blog_id"] as! String)
                        DispatchQueue.main.async {
                            self.addCard(id: blogID!, title: card["title"] as! String, author: card["author_name"] as! String)
                        }
                    }
                    
                    self.isRefreshingCards = false
                    
                    DispatchQueue.main.async {
                        if self.refreshControl.isRefreshing {
                            self.refreshControl.endRefreshing()
                        }
                        self.noInternetLabel.isHidden = true
                    }
                }
            }
        }
        
        task.resume()
        
    }
    
    @IBAction func onClickRefresh(_ sender: AnyObject) {
        
        for card in blogCards {
            card.removeFromSuperview()
        }
        
        blogCards = []
        
        //Ensures calling of scrollViewDidScroll which calls API to receive more cards
        scrollView.contentOffset.y = scrollView.contentSize.height-scrollView.frame.size.height
        
        //If there was no internet before the refresh
        if noInternetLabel.isHidden == false {
            self.getBlogIDs()
        }
        
        //Resetting loading activity indicator
        self.scrollView.removeConstraint(activityTopConstraint)
        self.loadingMoreCardsIndicator.removeConstraint(activityHeightConstraint)
        
        activityHeightConstraint = NSLayoutConstraint(item: loadingMoreCardsIndicator, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 40)
        activityTopConstraint = NSLayoutConstraint(item: loadingMoreCardsIndicator, attribute: .top, relatedBy: .equal, toItem: loadingMoreCardsIndicator.superview, attribute: .top, multiplier: 1.0, constant: 0)
        
        NSLayoutConstraint.activate([activityTopConstraint, activityHeightConstraint])
        
        loadingMoreCardsIndicator.isHidden = false
        loadingMoreCardsIndicator.startAnimating()
        
    }

}
