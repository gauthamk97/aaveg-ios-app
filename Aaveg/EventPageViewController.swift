//
//  EventPageViewController.swift
//  Aaveg
//
//  Created by Gautham Kumar on 28/12/16.
//  Copyright © 2016 Gautham Kumar. All rights reserved.
//

import UIKit

class EventPageViewController: UIViewController {

    let tempRuleBook = "<ol class=\"ol1\"><li class=\"li1\"><span class=\"s2\">Number of teams per hostel should be 2.</span></li><li class=\"li1\"><span class=\"s2\">There should be 6 members in each team. 3 of them being defenders and 3 of them being attackers.</span></li><li class=\"li1\"><span class=\"s2\">The attackers should only search for the enemy flag and pick it up from enemy base, and the defenders must defend the flag with sponge balls in marked zones. The attackers hit by the soft ball get eliminated from the round.</span></li><li class=\"li1\"><span class=\"s2\">The defenders cannot throw balls outside the zone.</span></li><li class=\"li1\"><span class=\"s2\">The defender must stand outside zone boundary while throwing.</span></li><li class=\"li1\"><span class=\"s2\">Each defender gets 1 ball which he or she can reuse. The enemy team cannot pick up the balls.</span></li><li class=\"li1\"><span class=\"s2\">If attacker catches the ball thrown by the other teams defender, then that defender is eliminated. </span></li><li class=\"li1\"><span class=\"s2\">Both teams must try to find the other teams flags. 3 possible locations will be given to each team where the other teams flag may be located. The defending zone will be located 25m from the location of flag. </span></li><li class=\"li1\"><span class=\"s2\">Before the game begins, all members should be at base. They can move only when the timer starts. </span></li><li class=\"li1\"><span class=\"s2\">No team member is allowed to carry any items whatsoever during the game. All items required will be provided.</span></li><li class=\"li1\"><span class=\"s2\">There will be 3 rounds in each game. The winner of each round is decided by the first team to get the oppositions flag. The team to first win 2 out of the 3 rounds, wins the game. All rounds are timed.</span></li><li class=\"li1\"><span class=\"s2\">The ball can be thrown anywhere on the body but a warning will be given if it is overarm. If a defender is given 3 warnings, he is eliminated from that round.</span></li><li class=\"li1\"><span class=\"s2\">There are 2 possible ways to win a round:</span></li><li class=\"li1\"><span class=\"s2\">In prelims 10 teams will play in random order(Other hostels) out of which 5 will win. Only 4 will be selected for semifinals. The team that gets disqualified is based on aggregate score. For example, a team to win 2-0 gets aggregate score of 2. A team to with with 2-1 gets aggregate score 1. The team with lowest aggregate score is eliminated. In case of a tie of aggregate scores, the team with highest average time of all rounds will be eliminated.</span></li></ol><ul><li class=\"li1\"><span class=\"s2\">Get the flag first.</span></li><li class=\"li1\"><span class=\"s2\">Eliminate the 3 attackers or defenders of other team.</span></li></ul>"
    
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
            self.venueLabel.text = "Venue : \(eventDetails["event_venue"] as! String)"
            self.dateLabel.text = "Date : \(eventDetails["event_date"] as! String)"
            self.timeLabel.text = "Time : \(eventDetails["event_start_time"] as! String) - \(eventDetails["event_end_time"] as! String)"
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
