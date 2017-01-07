//
//  EventPageViewController.swift
//  Aaveg
//
//  Created by Gautham Kumar on 28/12/16.
//  Copyright © 2016 Gautham Kumar. All rights reserved.
//

import UIKit

class EventPageViewController: UIViewController {

    let tempRuleBook = "<p><strong>Just A Minute (JAM) - Rulebook</strong></p><ul><li>JAM is an individual event.</li><li>There are no restrictions on the number of participants from each hostel.</li><li>Interested participants should register for the event through a google doc which will be put up.</li><li>The contestants will be split into groups of five. Every group will have five rounds.</li><li>Each round lasts a minute. A topic will be given and the contestant is supposed to speak on the topic adhering to certain rules which will be stated by the moderator/judge at the time of the event.</li><li>Judges&rsquo; decision will be final. No arguments will be encouraged.</li><li>Points will be given to the contestants based on their performance.</li><li>The 5 contestants with the highest number of points will move to the finals. The selection will NOT be based on the winners of each group. Only the overall points obtained by the individual contestant matter. So it is possible that no contestant from a group will make it to the finals or all five contestants from a group make it to the finals.</li><li>The top 5 contestants will participate in the finals. There will be 10 rounds of 1 minute each for the finals.</li><li>The same rules as in the prelims apply in the finals also. Additionally some new rules will be made up by the moderators at the time of finals which also need to be adhered to.</li><li>In case of a tie, separate round will be conducted only for the contestants who are on the same points and the victor is decided among them.</li></ul>"
    
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
        
        if events[selectedEvent] != nil {
            setDetails(eventDetails: events[selectedEvent]!)
        }
        
        else {
            self.getEventDetails()
        }
        
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
                   
                    //Storing event details
                    events[(eventDetails["event_name"] as? String)!] = eventDetails
                    
                    self.setDetails(eventDetails: eventDetails)
                }
                
            }
        
        }
        
        task.resume()
    }

    
    func setDetails(eventDetails: [String: Any]) {
        
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
            
            var realDescription = (eventDetails["event_desc"] as! String).html2String.replacingOccurrences(of: "\n", with: "\n\n")
            var ending = realDescription.substring(from: realDescription.index(realDescription.endIndex, offsetBy: -2))
            if ending == "\n\n" {
                realDescription = realDescription.substring(to: realDescription.index(realDescription.endIndex, offsetBy: -2))
            }
            
            self.descriptionTextView.text = realDescription
            
            let startTime = eventDetails["event_start_time"] as! String
            let endTime = eventDetails["event_end_time"] as! String
            let date = eventDetails["event_date"] as! String
            let dateSplits = date.components(separatedBy: "-")
            
            self.venueLabel.text = "Venue : \(eventDetails["event_venue"] as! String)"
            self.dateLabel.text = "Date : \(dateSplits[2])-\(dateSplits[1])-\(dateSplits[0])"
            self.timeLabel.text = "Time : \((startTime).substring(to: startTime.index(startTime.endIndex, offsetBy: -3))) - \((endTime.substring(to: endTime.index(endTime.endIndex, offsetBy: -3))))"
            self.categoryLabel.text = "Category : \(eventDetails["event_category"] as! String) Cup"
            var realcontent = self.tempRuleBook.html2String.replacingOccurrences(of: "\n", with: "\n\n")
            
            //Removing unnecessary newline at end
            ending = realcontent.substring(from: realcontent.index(realcontent.endIndex, offsetBy: -2))
            if ending == "\n\n" {
                realcontent = realcontent.substring(to: realcontent.index(realcontent.endIndex, offsetBy: -2))
            }
            print(realcontent)
            self.rulebookTextView.text = realcontent
        }
        
    }
    
}
