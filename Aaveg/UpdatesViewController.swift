//
//  UpdatesViewController.swift
//  Aaveg
//
//  Created by Gautham Kumar on 08/01/17.
//  Copyright © 2017 Gautham Kumar. All rights reserved.
//

import UIKit

class UpdatesViewController: UIViewController, SWRevealViewControllerDelegate {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var updateTiles: [UpdateTile] = []
    var isRevealViewOpen: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Updates"
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.revealViewController().delegate = self
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        }
        
        for i in 0..<updates.count {
            addTile(update: updates[updates.count-i-1])
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func revealController(_ revealController: SWRevealViewController!, willMoveTo position: FrontViewPosition) {
        
        if isRevealViewOpen {
            isRevealViewOpen = false
            scrollView.isUserInteractionEnabled = true
        }
            
        else {
            isRevealViewOpen = true
            scrollView.isUserInteractionEnabled = false
        }
    }
    
    func addTile(update: [String: String]) {
        
        let tempUpdateTile = UpdateTile(name: update["eventName"]!, first: update["first"]!, second: update["second"]!, third: update["third"]!)
        
        self.scrollView.addSubview(tempUpdateTile)
        
        if updateTiles.count == 0 {
            tempUpdateTile.setConstraints()
        }
        
        else {
            self.scrollView.removeConstraint(updateTiles[updateTiles.count-1].theBottomConstraint)
            tempUpdateTile.setConstraints()
            self.scrollView.removeConstraint(tempUpdateTile.theTopConstraint)
            let newTopConstraint = NSLayoutConstraint(item: tempUpdateTile, attribute: .top, relatedBy: .equal, toItem: updateTiles[updateTiles.count-1], attribute: .bottom, multiplier: 1, constant: 10)
            
            NSLayoutConstraint.activate([newTopConstraint])
            
        }
        
        updateTiles.append(tempUpdateTile)
        
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
