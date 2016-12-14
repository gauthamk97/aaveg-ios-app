//
//  BlogCardsViewController.swift
//  Aaveg
//
//  Created by Gautham Kumar on 13/12/16.
//  Copyright © 2016 Gautham Kumar. All rights reserved.
//

import UIKit

class BlogCardsViewController: UIViewController {

    var scrollView: UIScrollView!
    var blogCards: [BlogCard] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Initializing ScrollView
        
        scrollView = UIScrollView()
        scrollView.backgroundColor = UIColor.gray
        self.view.addSubview(scrollView)
        self.setScrollViewConstraints()
        
        //Creating cards
//        var tempCard = BlogCard(yPosition: 10, id: 1)
//        blogCards.append(tempCard)
        
//        tempCard = BlogCard(yPosition: 10 + CGFloat(blogCards.count)*(cardHeight+10), id: 2)
//        blogCards.append(tempCard)
//        
//        tempCard = BlogCard(yPosition: 10 + CGFloat(blogCards.count)*(cardHeight+10), id: 3)
//        blogCards.append(tempCard)
        
        for card in blogCards {
            self.scrollView.addSubview(card)
            card.setConstraints()
        }
        
        //Setting scroll height
        scrollView.contentSize.height = CGFloat(blogCards.count)*(cardHeight+10) + 10
        
        //Watching for when user selects a card
        NotificationCenter.default.addObserver(self, selector: #selector(self.cardSelected), name: NSNotification.Name(rawValue: "cardSelected"), object: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func cardSelected() {
        performSegue(withIdentifier: "toBlogView", sender: self)
    }
    
    func setScrollViewConstraints() {
        
        print("Setting scroll view constraints")
        
        let leftconstraint = NSLayoutConstraint(item: self.scrollView, attribute: .leading, relatedBy: .equal, toItem: scrollView.superview, attribute: .leading, multiplier: 1, constant: 0)
        
        let rightconstraint = NSLayoutConstraint(item: self.scrollView, attribute: .trailing, relatedBy: .equal, toItem: scrollView.superview, attribute: .trailing, multiplier: 1, constant: 0)
        
        let topconstraint = NSLayoutConstraint(item: self.scrollView, attribute: .top, relatedBy: .equal, toItem: scrollView.superview, attribute: .top, multiplier: 1, constant: 0)
        
        let bottomconstraint = NSLayoutConstraint(item: self.scrollView, attribute: .bottom, relatedBy: .equal, toItem: scrollView.superview, attribute: .bottom, multiplier: 1, constant: 0)
        
        NSLayoutConstraint.activate([leftconstraint,rightconstraint, bottomconstraint,topconstraint])
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
