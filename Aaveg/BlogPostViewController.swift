//
//  BlogPostViewController.swift
//  Aaveg
//
//  Created by Gautham Kumar on 13/12/16.
//  Copyright © 2016 Gautham Kumar. All rights reserved.
//

import UIKit

class BlogPostViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var authorImage: UIImageView!
    @IBOutlet weak var authorImageTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var authorImageBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var aboutAuthorText: UITextView!
    @IBOutlet weak var authorView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Checking for size of About the author page
        //checkAboutAuthorSize()
        
        //Setting status bar to white
        UIApplication.shared.statusBarStyle = .lightContent
        
        //Prevents gap at top of scroll view
        self.automaticallyAdjustsScrollViewInsets = false
        
        //Makes author icon circular
        authorImage.layer.cornerRadius = authorImage.frame.width/2
        
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
