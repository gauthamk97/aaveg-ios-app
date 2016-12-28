//
//  EventPageViewController.swift
//  Aaveg
//
//  Created by Gautham Kumar on 28/12/16.
//  Copyright © 2016 Gautham Kumar. All rights reserved.
//

import UIKit

class EventPageViewController: UIViewController {

    @IBOutlet weak var scrollViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Event Name"
        
        //self.expandScrollView()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Called when event is over
    func expandScrollView() {
        
        self.view.removeConstraint(scrollViewTopConstraint)
        let newTopConstraint = NSLayoutConstraint(item: self.scrollView, attribute: .top, relatedBy: .equal, toItem: topLayoutGuide, attribute: .bottom, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([newTopConstraint])
        
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
