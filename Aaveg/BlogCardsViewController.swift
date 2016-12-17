//
//  BlogCardsViewController.swift
//  Aaveg
//
//  Created by Gautham Kumar on 13/12/16.
//  Copyright © 2016 Gautham Kumar. All rights reserved.
//

import UIKit

class BlogCardsViewController: UIViewController {

    
    @IBOutlet weak var scrollView: UIScrollView!
    var blogCards: [BlogCard] = []
    var loadingMoreCardsIndicator: UIActivityIndicatorView!
    var activityHeightConstraint: NSLayoutConstraint!
    var activityTopConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Prevents vertical offset of scroll view
        self.automaticallyAdjustsScrollViewInsets = false
        
        //Setting up loading activity indicator
        loadingMoreCardsIndicator = UIActivityIndicatorView()
        self.scrollView.addSubview(loadingMoreCardsIndicator)
        loadingMoreCardsIndicator.color = UIColor.gray
        loadingMoreCardsIndicator.isHidden = false
        loadingMoreCardsIndicator.startAnimating()
        setActivityIndicatorConstraints()
        
        //Creating cards
        addCard()
        addCard()
        addCard()
        
        //Watching for when user selects a card
        NotificationCenter.default.addObserver(self, selector: #selector(self.cardSelected), name: NSNotification.Name(rawValue: "cardSelected"), object: nil)
        
        //Setting status bar to white
        UIApplication.shared.statusBarStyle = .lightContent
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func cardSelected() {
        performSegue(withIdentifier: "toBlogView", sender: self)
    }
    
    func setActivityIndicatorConstraints() {
        
        let leftconstraint = NSLayoutConstraint(item: loadingMoreCardsIndicator, attribute: .leading, relatedBy: .equal, toItem: loadingMoreCardsIndicator.superview, attribute: .leading, multiplier: 1.0, constant: 0)
        let centreXconstraint = NSLayoutConstraint(item: loadingMoreCardsIndicator, attribute: .centerX, relatedBy: .equal, toItem: loadingMoreCardsIndicator.superview, attribute: .centerX, multiplier: 1.0, constant: 0)
        let bottomconstraint = NSLayoutConstraint(item: loadingMoreCardsIndicator, attribute: .bottom, relatedBy: .equal, toItem: loadingMoreCardsIndicator.superview, attribute: .bottom, multiplier: 1.0, constant: 0)
        activityHeightConstraint = NSLayoutConstraint(item: loadingMoreCardsIndicator, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 40)
        
        loadingMoreCardsIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([leftconstraint, centreXconstraint, bottomconstraint, activityHeightConstraint])
        
    }
    
    func addCard() {
        
        let tempCard = BlogCard(id: blogCards.count + 1)
        
        //Removing activity's constraint to penultimate card
        if blogCards.count > 0 {
            self.scrollView.removeConstraint(activityTopConstraint)
        }
        
        blogCards.append(tempCard)
        self.scrollView.addSubview(blogCards[blogCards.count-1])
        blogCards[blogCards.count-1].setConstraints()
        
        activityTopConstraint = NSLayoutConstraint(item: self.loadingMoreCardsIndicator, attribute: .top, relatedBy: .equal, toItem: blogCards[blogCards.count-1], attribute: .bottom, multiplier: 1.0, constant: 0)
        
        NSLayoutConstraint.activate([activityTopConstraint])
        
        //Setting the new top constraint for the final card
        if tempCard.cardID > 1 {
        
            self.scrollView.removeConstraint(blogCards[blogCards.count-1].allConstraints["topconstraint"]!)
            let topconstraint = NSLayoutConstraint(item: blogCards[blogCards.count-1], attribute: .top, relatedBy: .equal, toItem: blogCards[blogCards.count-2], attribute: .bottom, multiplier: 1, constant: 10)
            NSLayoutConstraint.activate([topconstraint])
            blogCards[blogCards.count-1].allConstraints["topconstraint"] = topconstraint

        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
