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
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    //Winners
    @IBOutlet weak var firstPlaceLabel: UILabel!
    @IBOutlet weak var secondPlaceLabel: UILabel!
    @IBOutlet weak var thirdPlaceLabel: UILabel!
    
    @IBOutlet weak var venueLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var rulebookTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = selectedEvent
        
        self.getEventDetails()
        
        self.loadingIndicator.backgroundColor = self.scrollView.backgroundColor
        
        
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
    
    func getEventDetails() {
        
        self.loadingIndicator.startAnimating()
        
        let urlToHit = URL(string: "https://aaveg.net/events/geteventbyname")
        var request = URLRequest(url: urlToHit!)
        request.httpMethod = "POST"
        print(selectedEvent)
        let paramsString = "event_name=\(selectedEvent)"
        request.httpBody = paramsString.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            let httpStatus = response as? HTTPURLResponse
            
            if error != nil {
                if httpStatus?.statusCode == nil {
                    //no internet label
                }
                
                else {
                    print("Error : \(error)")
                }
                return
            }
            
            else if httpStatus?.statusCode != 200 {
                print("Status code not 200. It is \(httpStatus?.statusCode)")
                return
            }
            
            else {
                
                let responseString = String(data: data!, encoding: .utf8)
                let jsonData = responseString?.data(using: .utf8)
                if let json = try? JSONSerialization.jsonObject(with: jsonData!) as! [String: Any] {

                    let eventDetails = json["message"] as! [String: Any]
                   
                    DispatchQueue.main.async {
                        
                        if eventDetails["first_place"] as! String == "" {
                            self.expandScrollView()
                        }
                        
                        else {
                            self.firstPlaceLabel.text = eventDetails["first_place"] as? String
                            self.secondPlaceLabel.text = eventDetails["second_place"] as? String
                            self.thirdPlaceLabel.text = eventDetails["third_place"] as? String
                        }
                        
                        self.loadingIndicator.stopAnimating()
                        self.descriptionTextView.text = eventDetails["event_desc"] as! String
                        self.venueLabel.text = "Venue : \(eventDetails["event_venue"] as! String)"
                        self.dateLabel.text = "Date : \(eventDetails["event_date"] as! String)"
                        self.timeLabel.text = "Time : \(eventDetails["event_start_time"] as! String) - \(eventDetails["event_end_time"] as! String)"
                        self.categoryLabel.text = "Category : \(eventDetails["event_category"] as! String) Cup"
                    }
                    
                }
                
            }
        
        }
        
        task.resume()
    }

}
