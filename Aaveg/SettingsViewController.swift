//
//  SettingsViewController.swift
//  Aaveg
//
//  Created by Gautham Kumar on 07/01/17.
//  Copyright © 2017 Gautham Kumar. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var splashScreenSwitch: UISwitch!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Settings"
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        }
        
        self.splashScreenSwitch.addTarget(self, action: #selector(self.switchChange), for: UIControlEvents.valueChanged)
        
        UIApplication.shared.statusBarStyle = .lightContent
        
        let prefs = UserDefaults.standard
        let shouldSkipHomeScreen = prefs.bool(forKey: "skipHomeScreen")
        
        if shouldSkipHomeScreen {
            DispatchQueue.main.async {
                self.splashScreenSwitch.isOn = false
                self.descriptionLabel.text = "Splash Screen will be skipped on App Launch"
            }
        }
        
        else {
            DispatchQueue.main.async {
                self.splashScreenSwitch.isOn = true
                self.descriptionLabel.text = "Splash Screen will be displayed on App Launch"
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func switchChange() {
        
        let prefs = UserDefaults.standard
        
        if splashScreenSwitch.isOn {
            prefs.set(false, forKey: "skipHomeScreen")
            DispatchQueue.main.async {
                self.descriptionLabel.text = "Splash Screen will be displayed on App Launch"
            }
            
        }
        
        else {
            prefs.set(true, forKey: "skipHomeScreen")
            DispatchQueue.main.async {
                self.descriptionLabel.text = "Splash Screen will be skipped on App Launch"
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
