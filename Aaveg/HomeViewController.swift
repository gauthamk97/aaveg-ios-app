//
//  HomeViewController.swift
//  Aaveg
//
//  Created by Gautham Kumar on 02/11/16.
//  Copyright © 2016 Gautham Kumar. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    var backgroundImageView = UIImageView()
    var aavegLogoImageView = UIImageView()
    var leftGateImageView = UIImageView()
    var rightGateImageView = UIImageView()
    var boyImageView = UIImageView()
    var slideToEnterLabel = UILabel()
    var upSwipe = UISwipeGestureRecognizer()
    var cloudGen = CloudGenerator()
    
    var firstTouch: CGPoint!
    var leftGateCurrentXPosition: CGFloat!
    var rightGateCurrentXPosition: CGFloat!
    var leftGateMaxX: CGFloat!
    
    var swipeUpOccured: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Sky BGColor
        self.view.backgroundColor = UIColor(red: 0, green: 0.75, blue: 1, alpha: 1)
        
        //Setting up pan gesture recognizer for reveal view
        if self.revealViewController() != nil {
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        //Initializing UpSwipe
        upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.upSwipeDetected))
        upSwipe.direction = .up
       // self.view.addGestureRecognizer(upSwipe)
        swipeUpOccured = false

        //Setting up clouds
        cloudGen.generate(view: self.view)
        cloudGen.startAllAnimations(view: self.view)
        
        //Setting background
        backgroundImageView = UIImageView(image: UIImage(named: "bgSkyEffect"))
        backgroundImageView.frame = self.view.frame
        backgroundImageView.contentMode = .scaleAspectFit
        backgroundImageView.image = UIImage(named: "background")
        backgroundImageView.isUserInteractionEnabled = false
        
        self.view.addSubview(backgroundImageView)
        
        //Setting up leftGate ImageView
        let gateInitialImageHeight: CGFloat = gateToScreenInitialRatio*self.view.frame.width/gateAspectRatio
        let gateFinalImageHeight: CGFloat = gateToScreenFinalRatio*self.view.frame.width/gateAspectRatio
        
        leftGateImageView = UIImageView(image: UIImage(named:"leftGate"))
        //leftGateImageView.backgroundColor = UIColor.red
        leftGateImageView.alpha = 0
        leftGateImageView.frame = CGRect(x: gateInitialOffset*self.view.frame.width/2, y: self.view.frame.height-(gateInitialImageHeight*1.1), width: gateToScreenInitialRatio*self.view.frame.width, height: gateInitialImageHeight)
        
        self.view.addSubview(leftGateImageView)
        
        //Setting up rightGate ImageView
        rightGateImageView = UIImageView(image: UIImage(named:"rightGate"))
        //rightGateImageView.backgroundColor = UIColor.blue
        rightGateImageView.alpha = 0
        rightGateImageView.frame = CGRect(x: self.view.frame.width/2+(gateInitialOffset*self.view.frame.width/2), y: self.view.frame.height-(gateInitialImageHeight*1.1), width: gateToScreenInitialRatio*self.view.frame.width, height: gateInitialImageHeight)
        
        self.view.addSubview(rightGateImageView)
        
        //Popping Animation for Gate
        UIView.animate(withDuration: 1.7, delay: 0.0, usingSpringWithDamping: 20.0, initialSpringVelocity: 10.0, options: .curveEaseInOut, animations: {
            self.leftGateImageView.alpha = 1.0
            self.leftGateImageView.frame = CGRect(x: gateFinalOffset*self.view.frame.width/2, y: self.view.frame.height-(gateFinalImageHeight*1.1), width: gateToScreenFinalRatio*self.view.frame.width, height: gateFinalImageHeight)
            
            self.rightGateImageView.alpha = 1.0
            self.rightGateImageView.frame = CGRect(x: self.view.frame.width/2+(gateFinalOffset*self.view.frame.width/2), y: self.view.frame.height-(gateFinalImageHeight*1.1), width: gateToScreenFinalRatio*self.view.frame.width, height: gateFinalImageHeight)
            
        }) { (true) in
            //code
        }

        
        //Setting up boy's image view
        let boyInitialImageHeight: CGFloat = boyToScreenInitialRatio*self.view.frame.width/boyAspectRatio
        let boyFinalImageHeight: CGFloat = boyToScreenFinalRatio*self.view.frame.width/boyAspectRatio
        
        boyImageView = UIImageView(image: UIImage(named: "boyGlow"))
        boyImageView.frame = CGRect(x: boyInitialOffset*self.view.frame.width, y: self.view.frame.height-boyInitialImageHeight, width: boyToScreenInitialRatio*self.view.frame.width, height: boyInitialImageHeight)
        boyImageView.contentMode = .scaleAspectFit
        boyImageView.alpha = 1
        
        self.view.addSubview(boyImageView)
        
        //Popping Animation for Boy
        UIView.animate(withDuration: 1.7, delay: 0.0, usingSpringWithDamping: 20.0, initialSpringVelocity: 10.0, options: .curveEaseInOut, animations: {
            self.boyImageView.alpha = 1.0
            self.boyImageView.frame = CGRect(x: boyFinalOffset*self.view.frame.width, y: self.view.frame.height-boyFinalImageHeight, width: boyToScreenFinalRatio*self.view.frame.width, height: boyFinalImageHeight)
            
        }) { (true) in
            //code
        }
        
        //Setting up SwipeUp Label
        slideToEnterLabel = UILabel(frame: CGRect(x: 0, y: self.view.frame.height*0.505, width: self.view.frame.width, height: 20))
        slideToEnterLabel.text = "Slide Up to Enter"
        slideToEnterLabel.textColor = UIColor.white
        slideToEnterLabel.textAlignment = .center
        
        self.view.addSubview(slideToEnterLabel)
        
        //Fading in and out animation for swipe up label
        UIView.animate(withDuration: 1.0, delay: 0.0, options: [.repeat,.autoreverse], animations: {
            self.slideToEnterLabel.alpha = 0
        }) { (true) in
            //code
        }
        
        //Setting up aaveg logo's image view
        aavegLogoImageView = UIImageView(image: UIImage(named: "aavegLogo"))
        aavegLogoImageView.frame = CGRect(x: LogoOffset*self.view.frame.width, y: 0, width: LogoToScreenRatio*self.view.frame.width, height: self.view.frame.height)
        aavegLogoImageView.contentMode = .scaleAspectFit
        aavegLogoImageView.alpha = 0
        self.view.addSubview(aavegLogoImageView)
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func upSwipeDetected() {
        swipeUpOccured = true
        slideToEnterLabel.layer.removeAllAnimations()
        self.view.removeGestureRecognizer(upSwipe)
        
        //Popping Animation for Aaveg Logo
        UIView.animate(withDuration: 1.9, delay: 0.0, usingSpringWithDamping: 10.0, initialSpringVelocity: 10.0, options: .curveEaseIn, animations: {
            self.aavegLogoImageView.center.y = 0.13 * self.view.frame.height
            self.aavegLogoImageView.alpha = 1
        }) { (true) in
            //Completion code
        }
        
        UIView.animate(withDuration: 1.2, delay: 0.0, options: .curveEaseOut, animations: {
            self.leftGateImageView.frame.origin.x -= self.view.frame.width/2
            self.rightGateImageView.frame.origin.x += self.view.frame.width/2
            }) { (true) in
                //Completion code
        }
        
    
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if swipeUpOccured == true {
            return
        }
        
        if let touch = touches.first {
            self.firstTouch = touch.location(in: self.view)
        }
        
        self.leftGateCurrentXPosition = self.leftGateImageView.frame.origin.x
        self.rightGateCurrentXPosition = self.rightGateImageView.frame.origin.x
        self.leftGateMaxX = self.leftGateImageView.frame.maxX
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if swipeUpOccured == true {
            return
        }
        
        var difference: CGFloat = 0
        
        if let touch = touches.first {
            let currentTouch = touch.location(in: self.view)
            difference = self.firstTouch.y - currentTouch.y
        }
        
        if (self.leftGateMaxX - difference > self.view.frame.width/2) {
            return
        }
        
        if (self.leftGateMaxX - difference < (0.28*self.view.frame.width)) {
            swipeUpOccured = true
            self.upSwipeDetected()
            return
        }
        
        self.leftGateImageView.frame.origin.x = self.leftGateCurrentXPosition - difference
        self.rightGateImageView.frame.origin.x = self.rightGateCurrentXPosition + difference
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let gateFinalImageHeight: CGFloat = gateToScreenFinalRatio*self.view.frame.width/gateAspectRatio
        
        if swipeUpOccured == false {
            UIView.animate(withDuration: 1.2, delay: 0.0, options: .curveEaseOut, animations: {
                self.leftGateImageView.frame = CGRect(x: gateFinalOffset*self.view.frame.width/2, y: self.view.frame.height-(gateFinalImageHeight*1.1), width: gateToScreenFinalRatio*self.view.frame.width, height: gateFinalImageHeight)
                
                self.rightGateImageView.frame = CGRect(x: self.view.frame.width/2+(gateFinalOffset*self.view.frame.width/2), y: self.view.frame.height-(gateFinalImageHeight*1.1), width: gateToScreenFinalRatio*self.view.frame.width, height: gateFinalImageHeight)
            }) { (true) in
                //Completion Code
            }
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
