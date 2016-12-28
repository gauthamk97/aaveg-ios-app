//
//  ClustersViewController.swift
//  Aaveg
//
//  Created by Gautham Kumar on 26/12/16.
//  Copyright © 2016 Gautham Kumar. All rights reserved.
//

import UIKit

class ClustersViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    var tiles: [EventsTile] = []
    var clusters: [String] = ["Gaming", "Lits", "Miscallaneous", "Sports", "Music", "Dance", "Art"]
    var bgColors: [UIColor] = [UIColor.blue, UIColor.lightGray, UIColor.red, UIColor.green, UIColor.darkGray, UIColor.brown, UIColor.cyan]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Prevents gap at top
        self.automaticallyAdjustsScrollViewInsets = false
        
        for i in 0...6 {
            addTile(name: clusters[i], color: bgColors[i])
        }
        
        self.title = "Clusters"

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        
        for tile in tiles {
            tile.layer.cornerRadius = (self.view.frame.width-60)/4
        }
    }

    func addTile(name: String, color: UIColor) {
        
        let tempTile = EventsTile()
        tempTile.backgroundColor = color
        tempTile.setTitle(name, for: .normal)
        tempTile.setTitleColor(UIColor.white, for: .normal)
        self.addTileConstraints(tile: tempTile)
        tempTile.addTarget(self, action: #selector(self.onSelectingCluster), for: .touchUpInside)
        tiles.append(tempTile)
        
    }
    
    func addTileConstraints(tile: EventsTile) {
        
        tile.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(tile)
        
        //Making it circular
        tile.clipsToBounds = true
        tile.layer.cornerRadius = (self.view.frame.width-60)/4
        
        
        let widthConstraint = NSLayoutConstraint(item: tile, attribute: .width, relatedBy: .equal, toItem: scrollView, attribute: .width, multiplier: 0.5, constant: -30)
        let aspectRatioConstraint = NSLayoutConstraint(item: tile, attribute: .height, relatedBy: .equal, toItem: tile, attribute: .width, multiplier: 1, constant: 0)
        
        NSLayoutConstraint.activate([widthConstraint, aspectRatioConstraint])
        
        if tiles.count >= 2 {
            
            let topConstraint = NSLayoutConstraint(item: tile, attribute: .top, relatedBy: .equal, toItem: tiles[tiles.count-2], attribute: .bottom, multiplier: 1, constant: 10)
            
            NSLayoutConstraint.activate([topConstraint])
            
            if tiles.count%2==0 {
                
                scrollView.removeConstraint(tiles[tiles.count-2].bottomConstraint)
                tile.centreXConstraint = NSLayoutConstraint(item: tile, attribute: .centerX, relatedBy: .equal, toItem: scrollView, attribute: .centerX, multiplier: 1, constant: 0)
                tile.bottomConstraint = NSLayoutConstraint(item: tile, attribute: .bottom, relatedBy: .equal, toItem: scrollView, attribute: .bottom, multiplier: 1, constant: -10)
                
                NSLayoutConstraint.activate([tile.centreXConstraint, tile.bottomConstraint])
                
            }
                
            else {
                
                scrollView.removeConstraint(tiles[tiles.count-1].centreXConstraint)
                let oldTileCentreXConstraint = NSLayoutConstraint(item: tiles[tiles.count-1], attribute: .centerX, relatedBy: .equal, toItem: scrollView, attribute: .centerX, multiplier: 1/2, constant: 0)
                let newTileCentreXConstraint = NSLayoutConstraint(item: tile, attribute: .centerX, relatedBy: .equal, toItem: scrollView, attribute: .centerX, multiplier: 3/2, constant: 0)
                
                NSLayoutConstraint.activate([oldTileCentreXConstraint, newTileCentreXConstraint])
            }
            
        }
            
        else {
            
            let topConstraint = NSLayoutConstraint(item: tile, attribute: .top, relatedBy: .equal, toItem: scrollView, attribute: .top, multiplier: 1, constant: 10)
            
            if tiles.count%2==0 {
                tile.centreXConstraint = NSLayoutConstraint(item: tile, attribute: .centerX, relatedBy: .equal, toItem: scrollView, attribute: .centerX, multiplier: 1, constant: 0)
                tile.bottomConstraint = NSLayoutConstraint(item: tile, attribute: .bottom, relatedBy: .equal, toItem: scrollView, attribute: .bottom, multiplier: 1, constant: -10)
                
                NSLayoutConstraint.activate([tile.centreXConstraint, topConstraint, tile.bottomConstraint])
            }
                
            else {
                
                scrollView.removeConstraint(tiles[tiles.count-1].centreXConstraint)
                let oldTileCentreXConstraint = NSLayoutConstraint(item: tiles[tiles.count-1], attribute: .centerX, relatedBy: .equal, toItem: scrollView, attribute: .centerX, multiplier: 1/2, constant: 0)
                let newTileCentreXConstraint = NSLayoutConstraint(item: tile, attribute: .centerX, relatedBy: .equal, toItem: scrollView, attribute: .centerX, multiplier: 3/2, constant: 0)
                
                NSLayoutConstraint.activate([oldTileCentreXConstraint, newTileCentreXConstraint, topConstraint])
                
            }
            
        }
        
    }
    
    func onSelectingCluster() {
        
        performSegue(withIdentifier: "toEventsView", sender: self)
        
    }
    
}
