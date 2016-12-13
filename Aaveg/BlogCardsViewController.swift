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
        scrollView = UIScrollView(frame: self.view.frame)
        scrollView.backgroundColor = UIColor.gray
        scrollView.contentSize.width = screensize.width
        self.view.addSubview(scrollView)
        
        //Creating cards
        var tempCard = BlogCard(yPosition: 10, id: 1)
        blogCards.append(tempCard)
        
        tempCard = BlogCard(yPosition: 10 + CGFloat(blogCards.count)*(cardHeight+10), id: 2)
        blogCards.append(tempCard)
        
        tempCard = BlogCard(yPosition: 10 + CGFloat(blogCards.count)*(cardHeight+10), id: 3)
        blogCards.append(tempCard)
        
        for card in blogCards {
            self.scrollView.addSubview(card)
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
