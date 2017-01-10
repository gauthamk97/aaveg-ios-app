//
//  ScheduleViewController.swift
//  Aaveg
//
//  Created by Gautham Kumar on 08/01/17.
//  Copyright © 2017 Gautham Kumar. All rights reserved.
//

import UIKit

class ScheduleViewController: UIViewController, SWRevealViewControllerDelegate, UIScrollViewDelegate {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var insideView: UIView!
    @IBOutlet weak var timedOutLabel: UILabel!
    @IBOutlet weak var reloadButton: UIButton!
    
    var isRevealViewOpen: Bool = false
    var viewHasLoaded: Bool = false
    var scrollView: UIScrollView!
    var scheduleImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Hiding no internet stuff
        self.timedOutLabel.isHidden = true
        self.reloadButton.isHidden = true
        
        viewHasLoaded = false
        self.view.layoutIfNeeded()
        
        self.revealViewController().delegate = self
        self.automaticallyAdjustsScrollViewInsets = false
        self.title = "Schedule"
        
        //White status bar
        UIApplication.shared.statusBarStyle = .lightContent
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        }
        
        scrollView = UIScrollView(frame: insideView.frame)
        scrollView.delegate = self
        scrollView.backgroundColor = UIColor.black
        scrollView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        insideView.addSubview(scrollView)
        
        if isSchedulePresent {
            print("Schedule already present")
            DispatchQueue.main.async() { () -> Void in
                
                self.scheduleImage = UIImageView(image: UIImage(data: scheduleData))
                self.scrollView.contentSize = self.scheduleImage.bounds.size
                self.scrollView.addSubview(self.scheduleImage)
                self.setZoomScale()
                self.viewHasLoaded = true
                isSchedulePresent = true
                self.loadingIndicator.stopAnimating()
                
            }
        }
        
        else {
            if let checkedUrl = URL(string: "https://aaveg.net/schedule.jpg") {
                downloadImage(url: checkedUrl)
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        
        if isSchedulePresent && viewHasLoaded {
            setZoomScale()
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.scheduleImage
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        
        scheduleImage.center.y = scrollView.center.y
        
    }
    
    func setZoomScale() {
        
        let scrollViewSize = scrollView.bounds.size
        
        let imageViewSize = scheduleImage.bounds.size
        
        let widthScale = scrollViewSize.width / imageViewSize.width
        var heightScale: CGFloat = 0
        
        heightScale = scrollViewSize.height / imageViewSize.height

        scrollView.maximumZoomScale = max(widthScale, heightScale)
        scrollView.minimumZoomScale = min(widthScale, heightScale)
        
        if UIApplication.shared.statusBarOrientation == .portrait {
            scrollView.zoomScale = (3*scrollView.maximumZoomScale)/4
        }
            
        else {
            scrollView.zoomScale = scrollView.maximumZoomScale
        }
        
        if viewHasLoaded == false {
            self.scrollView.contentOffset = CGPoint(x: 0, y: 0)
        }
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
    
    func nointernet() {
        DispatchQueue.main.async {
            self.loadingIndicator.stopAnimating()
            self.timedOutLabel.isHidden = false
            self.reloadButton.isHidden = false
        }
    }
    
    @IBAction func onReloadClick(_ sender: AnyObject) {
        DispatchQueue.main.async {
            self.loadingIndicator.startAnimating()
            self.timedOutLabel.isHidden = true
            self.reloadButton.isHidden = true
        }
        if let checkedUrl = URL(string: "https://aaveg.net/schedule.jpg") {
            downloadImage(url: checkedUrl)
        }
    }
    
    func downloadImage(url: URL) {
        print("Download Started")
        self.loadingIndicator.startAnimating()
        isSchedulePresent = false
        getDataFromUrl(url: url) { (data, response, error)  in
            guard let data = data, error == nil else {
                print("error")
                self.nointernet()
                return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() { () -> Void in
                
                self.scheduleImage = UIImageView(image: UIImage(data: data))
                self.scrollView.contentSize = self.scheduleImage.bounds.size
                self.scrollView.addSubview(self.scheduleImage)
                self.setZoomScale()
                self.viewHasLoaded = true
                
                scheduleData = data
                
                isSchedulePresent = true
                
                self.loadingIndicator.stopAnimating()
                self.setZoomScale()
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
