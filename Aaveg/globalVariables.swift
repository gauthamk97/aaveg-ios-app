//
//  globalVariables.swift
//  Aaveg
//
//  Created by Gautham Kumar on 02/11/16.
//  Copyright © 2016 Gautham Kumar. All rights reserved.
//

import Foundation
import UIKit

let LogoToScreenRatio: CGFloat = 7/8
let LogoOffset: CGFloat = (1 - LogoToScreenRatio)/2

let boyToScreenInitialRatio: CGFloat = 0.35
let boyToScreenFinalRatio: CGFloat = 0.5

let boyInitialOffset: CGFloat = (1 - boyToScreenInitialRatio)/2
let boyFinalOffset: CGFloat = (1 - boyToScreenFinalRatio)/2

let boyAspectRatio: CGFloat = 1417/2093

let gateToScreenInitialRatio: CGFloat = 0.35
let gateToScreenFinalRatio: CGFloat = 0.5

let gateInitialOffset: CGFloat = (0.5 - gateToScreenInitialRatio)/2
let gateFinalOffset: CGFloat = (0.5 - gateToScreenFinalRatio)/2

let gateAspectRatio: CGFloat = 542/634

let cloudAspectRatio: CGFloat = 6378/3839

//Colors for scoreboard view

let scoreboardBGColor = UIColor(colorLiteralRed: 0.2235, green: 0.30588, blue: 0.38039, alpha: 1.0)
let pageControlBGColor = UIColor(colorLiteralRed: 0.1686, green: 0.2431, blue: 0.3098, alpha: 1.0)
let diamondColor = UIColor(colorLiteralRed: 0.70588, green: 0.37647, blue: 0.52157, alpha: 1.0)
let coralColor = UIColor(colorLiteralRed: 0.1882353, green: 0.490196, blue: 0.68627, alpha: 1.0)
let jadeColor = UIColor(colorLiteralRed: 0.60392, green: 0.58039, blue: 0.41176, alpha: 1.0)
let agateColor = UIColor(colorLiteralRed: 0.2902, green: 0.615686, blue: 0.627451, alpha: 1.0)
let opalColor = UIColor(colorLiteralRed: 0.52157, green: 0.4470588, blue: 0.78039, alpha: 1.0)

//Events data
let emptyDictionary: [[String:Any]] = [[:]]
var culturalEvents: [[String:Any]] = [[:]]

func obtainScoreboardData() {
    
    let urlToHit = URL(string: "https://aaveg.net/scoreboard/getall")
    var request = URLRequest(url: urlToHit!)
    request.httpMethod = "POST"
    request.httpBody = nil //Parameters to send, if needed (must be encoded)
    
    let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
        
        let httpStatus = response as? HTTPURLResponse
        
        if (error != nil) {
            if (httpStatus?.statusCode == nil) {
                print("NO INTERNET")
            }
            else {
                print("Error occured : \(error)")
            }
            return;
        }
            
        else if httpStatus?.statusCode != 200 {
            print("Error : HTTPStatusCode is \(httpStatus?.statusCode)")
            return
        }
            
        else {
            let responseString = String(data: data!, encoding: .utf8)
            let jsonData = responseString?.data(using: .utf8)
            if let json = try? JSONSerialization.jsonObject(with: jsonData!) as! [String: Any] {
                let message = json["message"] as! [String: Any]
                let culturals = message["Culturals"] as! [[String: Any]]
                for item in culturals {
                    culturalEvents.append(item)
                }
            }
            
        }
        
    })
    
    task.resume()
    
}
