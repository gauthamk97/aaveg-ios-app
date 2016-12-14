//
//  BlogPostViewController.swift
//  Aaveg
//
//  Created by Gautham Kumar on 13/12/16.
//  Copyright © 2016 Gautham Kumar. All rights reserved.
//

import UIKit

class BlogPostViewController: UIViewController {

    var scrollView: UIScrollView!
    var coverImage: UIImageView!
    var titleLabel: UILabel!
    var subtitleLabel: UILabel!
    var contentView: UITextView!
    var authorImage: UIImageView!
    var authorLabel: UILabel!
    var authorDescription: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setting up scrollView
        scrollView = UIScrollView(frame: self.view.frame)
        scrollView.backgroundColor = blogPageBackgroundColor
        scrollView.contentSize.width = screensize.width
        self.view.addSubview(scrollView)
        
        //Setting up cover image
        coverImage = UIImageView(frame: CGRect(x: 0, y: 0, width: coverImageWidth, height: coverImageHeight))
        coverImage.backgroundColor = UIColor.red
        coverImage.contentMode = .scaleAspectFit
        self.scrollView.addSubview(coverImage)
        
        //Setting up title label
        titleLabel = UILabel(frame: CGRect(x: contentOffsets, y: coverImageHeight, width: titleWidth, height: titleHeight))
        titleLabel.backgroundColor = UIColor.blue
        titleLabel.text = "This is text"
        self.scrollView.addSubview(titleLabel)
        
        //Setting up subtitle label
        subtitleLabel = UILabel(frame: CGRect(x: contentOffsets, y: coverImageHeight+titleHeight, width: subtitleWidth, height: subtitleHeight))
        subtitleLabel.backgroundColor = UIColor.blue
        subtitleLabel.text = "This is subtitle"
        self.scrollView.addSubview(subtitleLabel)
        
        //Setting up the content view
        contentView = UITextView(frame: CGRect(x: contentOffsets, y: coverImageHeight+titleHeight+subtitleHeight, width: contentViewWidth, height: scrollView.frame.height-coverImageHeight-titleHeight-subtitleHeight))
        contentView.backgroundColor = UIColor.gray
//        contentView.isEditable = false
        contentView.contentSize.width = contentViewWidth
        contentView.contentSize.height = scrollView.frame.height-coverImageHeight-titleHeight-subtitleHeight
        contentView.text = "This is the content. This is the content. This is the content. This is the content. This is the content. This is the content. This is the content. This is the content. This is the content. This is the content. This is the content. This is the content. This is the content. This is the content. This is the content. This is the content. This is the content. This is the content. This is the content. This is the content. This is the content. This is the content. This is the content. This is the content. This is the content. This is the content. This is the content. This is the content. This is the content. This is the content. This is the content. This is the content. This is the content. This is the content. This is the content. This is the content. This is the content. This is the content. This is the content. This is the content. This is the content. This is the content. This is the content. This is the content. This is the content. This is the content. This is the content. This is the content. This is the content. This is the content. This is the content. This is the content. This is the content. This is the content. This is the content. This is the content. This is the content. This is the content. This is the content. This is the content. This is the content. This is the content. This is the content. This is the content. This is the content. This is the content. This is the content. This is the content. This is the content. This is the content. This is the content. This is the content. This is the content. This is the content. This is the content. This is the content. This is the content. This is the content. This is the content. This is the content. This is the content. This is the content. This is the content. This is the content. This is the content. This is the content. This is the content. This is the content. This is the content. This is the content. This is the content. This is the content. This is the content. This is the content. This is the content. This is the content. This is the content. This is the content. This is the content. This is the content. This is the content. This is the content. This is the content. This is the content. This is the content. This is the content. This is the content. This is the content. This is the content. This is the content. This is the content. "
        self.scrollView.addSubview(contentView)
        
        scrollView.contentSize.height = coverImageHeight+titleHeight+subtitleHeight
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
