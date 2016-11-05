//
//  Cloud.swift
//  Aaveg
//
//  Created by Gautham Kumar on 03/11/16.
//  Copyright © 2016 Gautham Kumar. All rights reserved.
//

import UIKit

class Cloud: UIImageView {

    var isPartOfFirstSet: Bool!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.image = UIImage(named: "cloud")
        //self.backgroundColor = UIColor.green
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animate(view: UIView) {
        
        UIView.animate(withDuration: 10.0, delay: 2, options: [.curveLinear, .repeat], animations: {
            self.frame.origin.x = self.frame.origin.x - (2*view.frame.width)
            }, completion: nil)
        
    }
    
}
