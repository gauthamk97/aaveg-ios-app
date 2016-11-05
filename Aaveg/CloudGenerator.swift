//
//  CloudGenerator.swift
//  Aaveg
//
//  Created by Gautham Kumar on 03/11/16.
//  Copyright © 2016 Gautham Kumar. All rights reserved.
//

import Foundation
import UIKit

class CloudGenerator {
    
    var allClouds = [Cloud]()
    var yPositions = [CGFloat]()
    
    func generate(view: UIView) {
        
        var xPosition,yPosition: CGFloat
        let viewWidth = view.frame.width
        
        for i in 0...5 {
            xPosition = CGFloat(i)*viewWidth/CGFloat(3) - 20
            yPosition = CGFloat(arc4random_uniform(UInt32(view.frame.height/3))) + 10
            yPositions.append(yPosition)
            
            let tempCloud = Cloud(frame: CGRect(x: xPosition, y: yPosition, width: viewWidth/2, height: viewWidth/(2*cloudAspectRatio)))
            
            allClouds.append(tempCloud)
            view.addSubview(allClouds[i])
        }
        
        for i in 6...8 {
            xPosition = CGFloat(i)*viewWidth/CGFloat(3) - 20
            yPosition = yPositions[i-6]
            
            let tempCloud = Cloud(frame: CGRect(x: xPosition, y: yPosition, width: viewWidth/2, height: viewWidth/(2*cloudAspectRatio)))
            
            allClouds.append(tempCloud)
            view.addSubview(allClouds[i])
        }
        
    }
    
    func startAllAnimations(view: UIView) {
        
        for i in 0...8 {
            UIView.animate(withDuration: 10, delay: 0, options: [.curveLinear,.repeat], animations: { 
                self.allClouds[i].frame.origin.x -= (2*view.frame.width)
                }, completion: nil)
        }
    }

}
