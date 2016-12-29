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
    
    //Scores
    var scores: [String: Double] = ["agate": 0, "diamond": 0, "coral": 0, "opal": 0, "jade": 0]
    var tempScores: [String: Double] = ["agate": 0, "diamond": 0, "coral": 0, "opal": 0, "jade": 0]
    var firstPlaceWinners: String = ""
    var secondPlaceWinners: String = ""
    var thirdPlaceWinners: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Event Name"
        
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
        
        let urlToHit = URL(string: "https://aaveg.net/scoreboard/geteventscores")
        var request = URLRequest(url: urlToHit!)
        request.httpMethod = "POST"
        let paramsString = "event_name=Terribly Tiny Tales"
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
                    
                    
                    let message = json["message"] as! [[String: Any]]
                    let eventDetails = message[0]
                    
                    self.scores["agate"] = Double.init(eventDetails["agate_score"] as! String)!
                    self.scores["coral"] = Double.init(eventDetails["coral_score"] as! String)!
                    self.scores["diamond"] = Double.init(eventDetails["diamond_score"] as! String)!
                    self.scores["jade"] = Double.init(eventDetails["jade_score"] as! String)!
                    self.scores["opal"] = Double.init(eventDetails["opal_score"] as! String)!
                    
                    self.checkScores()
                    
                    DispatchQueue.main.async {
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

    func checkScores() {
        
        if self.scores["agate"] == 0 && self.scores["coral"] == 0 && self.scores["diamond"] == 0 && self.scores["jade"] == 0 && self.scores["opal"] == 0 {
            self.expandScrollView()
            return
        }
        
        tempScores = scores
        
        //First Place
        let firstPlaceScore = tempScores.values.max()
        checkSimilarity(value: firstPlaceScore!, place: 1)
        
        //Second Place
        let secondPlaceScore = tempScores.values.max()
        checkSimilarity(value: secondPlaceScore!, place: 2)
       
        //Third Place
        let thirdPlaceScore = tempScores.values.max()
        checkSimilarity(value: thirdPlaceScore!, place: 3)
        
        if firstPlaceWinners.characters.count >= 2 {
            firstPlaceWinners = firstPlaceWinners.substring(to: firstPlaceWinners.index(firstPlaceWinners.endIndex, offsetBy: -2))
        }
        
        if secondPlaceWinners.characters.count >= 2 {
            secondPlaceWinners = secondPlaceWinners.substring(to: secondPlaceWinners.index(secondPlaceWinners.endIndex, offsetBy: -2))
        }
        
        if thirdPlaceWinners.characters.count >= 2 {
            thirdPlaceWinners = thirdPlaceWinners.substring(to: thirdPlaceWinners.index(thirdPlaceWinners.endIndex, offsetBy: -2))
        }
        
        DispatchQueue.main.async {
            self.firstPlaceLabel.text = self.firstPlaceWinners
            self.secondPlaceLabel.text = self.secondPlaceWinners
            self.thirdPlaceLabel.text = self.thirdPlaceWinners
        }
        
    }
    
    func checkSimilarity(value: Double, place: Int) {
        
        if scores["agate"] == value {
            tempScores.removeValue(forKey: "agate")
            
            switch place {
            case 1:
                firstPlaceWinners.append("Agate, ")
            case 2:
                secondPlaceWinners.append("Agate, ")
            case 3:
                thirdPlaceWinners.append("Agate, ")
            default:
                print("Error")
            }

        }
        
        if scores["diamond"] == value {
            tempScores.removeValue(forKey: "diamond")
            
            switch place {
            case 1:
                firstPlaceWinners.append("Diamond, ")
            case 2:
                secondPlaceWinners.append("Diamond, ")
            case 3:
                thirdPlaceWinners.append("Diamond, ")
            default:
                print("Error")
            }
            
        }
        
        if scores["coral"] == value {
            tempScores.removeValue(forKey: "coral")
            
            switch place {
            case 1:
                firstPlaceWinners.append("Coral, ")
            case 2:
                secondPlaceWinners.append("Coral, ")
            case 3:
                thirdPlaceWinners.append("Coral, ")
            default:
                print("Error")
            }
            
        }
        
        if scores["opal"] == value {
            tempScores.removeValue(forKey: "opal")
            
            switch place {
            case 1:
                firstPlaceWinners.append("Opal, ")
            case 2:
                secondPlaceWinners.append("Opal, ")
            case 3:
                thirdPlaceWinners.append("Opal, ")
            default:
                print("Error")
            }
            
        }
        
        if scores["jade"] == value {
            tempScores.removeValue(forKey: "jade")
            
            switch place {
            case 1:
                firstPlaceWinners.append("Jade, ")
            case 2:
                secondPlaceWinners.append("Jade, ")
            case 3:
                thirdPlaceWinners.append("Jade, ")
            default:
                print("Error")
            }
            
        }
        
    }
}
