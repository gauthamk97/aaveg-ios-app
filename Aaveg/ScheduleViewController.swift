//
//  ScheduleViewController.swift
//  Aaveg
//
//  Created by Gautham Kumar on 08/01/17.
//  Copyright © 2017 Gautham Kumar. All rights reserved.
//

import UIKit

class ScheduleViewController: UIViewController, SWRevealViewControllerDelegate {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    var scheduleImage: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    var isRevealViewOpen: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.revealViewController().delegate = self
        
        self.title = "Schedule"
        
        //White status bar
        UIApplication.shared.statusBarStyle = .lightContent
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        }
        
        if isSchedulePresent {
            print("Schedule already present")
            DispatchQueue.main.async() { () -> Void in
                
                self.scheduleImage = UIImageView(image: UIImage(data: scheduleData))
                
                self.scrollView.contentSize = self.scheduleImage.bounds.size
                self.scrollView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
                
                self.scrollView.addSubview(self.scheduleImage)
                
                let centreYConstraint = NSLayoutConstraint(item: self.scheduleImage, attribute: .centerY, relatedBy: .equal, toItem: self.scrollView, attribute: .centerY, multiplier: 1, constant: 0)
                self.scheduleImage.translatesAutoresizingMaskIntoConstraints = false
                self.scrollView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([centreYConstraint])
                
                isSchedulePresent = true
                self.loadingIndicator.stopAnimating()
            }
        }
        
        else {
            if let checkedUrl = URL(string: "https://aaveg.net/splash-assets/logo.png") {
                downloadImage(url: checkedUrl)
            }
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
    
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    
    func downloadImage(url: URL) {
        print("Download Started")
        self.loadingIndicator.startAnimating()
        isSchedulePresent = false
        getDataFromUrl(url: url) { (data, response, error)  in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() { () -> Void in
                
                self.scheduleImage = UIImageView(image: UIImage(data: data))
                
                self.scrollView.contentSize = self.scheduleImage.bounds.size
                self.scrollView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
                
                self.scrollView.addSubview(self.scheduleImage)
                
                let centreYConstraint = NSLayoutConstraint(item: self.scheduleImage, attribute: .centerY, relatedBy: .equal, toItem: self.scrollView, attribute: .centerY, multiplier: 1, constant: 0)
                self.scheduleImage.translatesAutoresizingMaskIntoConstraints = false
                self.scrollView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([centreYConstraint])

                scheduleData = data
                isSchedulePresent = true
                self.loadingIndicator.stopAnimating()
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
