//
//  globalVariables.swift
//  Aaveg
//
//  Created by Gautham Kumar on 02/11/16.
//  Copyright © 2016 Gautham Kumar. All rights reserved.
//

import Foundation
import UIKit

let baseColor = UIColor(colorLiteralRed: 0.169, green: 0.243, blue: 0.31, alpha: 0)

//For locking portrait in splash screen
var isInSplashScreen: Bool = true

let LogoToScreenRatio: CGFloat = 7/8
let LogoOffset: CGFloat = (1 - LogoToScreenRatio)/2

let boyToScreenInitialRatio: CGFloat = 0.15
let boyToScreenFinalRatio: CGFloat = 0.25

let boyInitialOffset: CGFloat = (1 - boyToScreenInitialRatio)/2
let boyFinalOffset: CGFloat = (1 - boyToScreenFinalRatio)/2

let boyAspectRatio: CGFloat = 871/1919

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

//Booleans indicating whether data is present or loading
var CultCupDataPresent: Bool = false
var SportsCupDataPresent: Bool = false
var SpectrumCupDataPresent: Bool = false

var isObtainingCultCupData: Bool = false
var isObtainingSportsCupData: Bool = false
var isObtainingSpectrumCupData: Bool = false

var currentScoreboardPage: Int = 1
var wasInternetPresent: Bool = true
var isInternetPresent: Bool = true

//Events data
var culturalEvents: [[String:Any]] = [[:]]
var sportsEvents: [[String:Any]] = [[:]]
var spectrumEvents: [[String:Any]] = [[:]]
var cultCupTotals: [Double] = [0,0,0,0,0]
var sportsCupTotals: [Double] = [0,0,0,0,0]
var spectrumCupTotals: [Double] = [0,0,0,0,0]

let hostelNames = ["Diamond", "Coral", "Jade", "Agate", "Opal"]

///Event Tile Colours
let eventTileColour1 = UIColor(colorLiteralRed: 0.165, green: 0.322, blue: 0.263, alpha: 1)
let eventTileColour2 = UIColor(colorLiteralRed: 0.2, green: 0.192, blue: 0.333, alpha: 1)
let eventTileColour3 = UIColor(red: 0.478, green: 0.424, blue: 0.243, alpha: 1.0)

func obtainScoreboardData(index: Int) {
    
    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "obtaining\(index)stcupdata"), object: nil)
    
    let urlToHit = URL(string: "https://aaveg.net/scoreboard/getall")
    var request = URLRequest(url: urlToHit!)
    request.httpMethod = "POST"
    request.httpBody = nil //Parameters to send, if needed (must be encoded)
    
    let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
        
        let httpStatus = response as? HTTPURLResponse
        
        if (error != nil) {
            if (httpStatus?.statusCode == nil) {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "nointernet"), object: nil)
                print("NO INTERNET")
                isInternetPresent = false
                wasInternetPresent = false
            }
            else {
                print("Error occured : \(error)")
            }
            return;
        }
            
        else if httpStatus?.statusCode != 200 {
            print("Error : HTTPStatusCode is \(httpStatus?.statusCode)")
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "servererror"), object: nil)
            return
        }
            
        else {
            let responseString = String(data: data!, encoding: .utf8)
            let jsonData = responseString?.data(using: .utf8)
            if let json = try? JSONSerialization.jsonObject(with: jsonData!) as! [String: Any] {
                if (json["status_code"] as! Int) != 200 {
                    print("ERROR. STATUS CODE = \(json["status_code"] as! Int)")
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "servererror"), object: nil)
                    return
                }
                
                let message = json["message"] as! [String: Any]
                if index==1 {
                    CultCupDataPresent = true
                    culturalEvents.removeAll()
                    let culturals = message["Culturals"] as! [[String: Any]]
                    for item in culturals {
                        culturalEvents.append(item)
                    }
                }
                
                else if index==2 {
                    SportsCupDataPresent = true
                    sportsEvents.removeAll()
                    let sports = message["Sports"] as! [[String: Any]]
                    for item in sports {
                        sportsEvents.append(item)
                    }
                }
                
                else {
                    SpectrumCupDataPresent = true
                    spectrumEvents.removeAll()
                    let spectrum = message["Spectrum"] as! [[String: Any]]
                    for item in spectrum {
                        spectrumEvents.append(item)
                }
            }
            
            isInternetPresent = true
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "\(index)stcupdataobtained"), object: nil)
            }
        
        }})
    
    task.resume()
    
}

//Blog Card Constants
let screensize = UIScreen.main.bounds
let cardXOffset: CGFloat = (5/375)*screensize.width
let cardWidth: CGFloat = (365/375)*screensize.width
let imageAspectRatio: CGFloat = 1/2
let imageCardWidth: CGFloat = cardWidth
let imageCardHeight: CGFloat = imageCardWidth*imageAspectRatio
let titleCardWidth: CGFloat = cardWidth
let titleCardHeight: CGFloat = 30
let authorCardWidth: CGFloat = cardWidth
let authorCardHeight: CGFloat = 30
let cardHeight: CGFloat = imageCardHeight + titleCardHeight + authorCardHeight

//Blog Page Constants
let contentOffsets: CGFloat = (10/375)*screensize.width

let blogPageBackgroundColor = UIColor(red: 0.9098, green: 0.91765, blue: 0.9647, alpha: 1.0)
let coverImageWidth: CGFloat = screensize.width
let coverImageHeight: CGFloat = coverImageWidth*imageAspectRatio
let titleWidth: CGFloat = screensize.width-(2*contentOffsets)
let titleHeight: CGFloat = 60
let subtitleWidth: CGFloat = screensize.width-(2*contentOffsets)
let subtitleHeight: CGFloat = 45
let contentViewWidth: CGFloat = screensize.width-(2*contentOffsets)

var selectedBlogCard = BlogCard(id: 0, title: "temp", author: "temp")
var selectedBlogID: Int = 0

//Blog author About Me's

let KiranAboutMe = "A perpetually sleep deprived and hungry human being who writes and plays basketball.\n\nI'm a Mallu who never became one of them #mwonjanz"

let MathirushAboutMe = "Lost in the Patterns of Music, Sport and Life. A Man of Few Words. Quoraholic but still stuck in Eternal Sonder.\n\nAlso, mildly OCD."

let AnirudhAboutMe = "Lazy. Optimistic. Meticulous. Pedantic. Fascinating.\n\nI am a multicultural Bengali who loves everything under the sun as long as it isn't in LHC."

let TanviAboutMe = "Blogger. Day dreamer. Approachable, outgoing, tall wheatish person.\n\nWrites to express.\n\nAlso, I'm fluffy."

let AvinashAboutMe = "A Telugu speaking chennaiite who is independent, curious, ever-hungry and a bit too lazy.\n\nGive me any song, I can dance for it.\n\nGive me any topic, I will write about it."

let ContentTeamAboutMe = "The Content Team is the best peace out."

//Blog Posts
var blogPosts: [Int: [String: Any]] = [:]

func initializeBlogPost(id: Int) {
    blogPosts[id] = ["isImagePresent": false, "isContentPresent": false]
}

//Get Cluster and Events List

var isClusterAndEventsPresent = false
var clusters: [String: [String]] = [:]
var events: [String: [String: Any]] = [:]
var selectedCluster: String = ""
var selectedEvent: String = ""
var listOfClusters: [String] = []
var noInternetForClusters: Bool = false

func getClusterAndEvents() {
    isClusterAndEventsPresent = false
    let urlToHit = URL(string: "https://aaveg.net/events/getclusterevents")
    var request = URLRequest(url: urlToHit!)
    request.httpMethod = "POST"
    request.httpBody = nil //Parameters to send, if needed (must be encoded)
    
    let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
        
        let httpStatus = response as? HTTPURLResponse
        
        if (error != nil) {
            if (httpStatus?.statusCode == nil) {
                print("NO INTERNET")
                noInternetForClusters = true
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "nointernetforclusters"), object: nil)
            }
            else {
                print("Error occured : \(error)")
            }
            return;
        }
            
        else if httpStatus?.statusCode != 200 {
            print("Error : HTTPStatusCode is \(httpStatus?.statusCode)")
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "servererror"), object: nil)
            return
        }
            
        else {
            let responseString = String(data: data!, encoding: .utf8)
            let jsonData = responseString?.data(using: .utf8)
            if let json = try? JSONSerialization.jsonObject(with: jsonData!) as! [String: Any] {
                if (json["status_code"] as! Int) != 200 {
                    print("ERROR. STATUS CODE = \(json["status_code"] as! Int)")
//                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "servererror"), object: nil)
                    return
                }
                
                clusters = json["message"] as! [String: [String]]
                isClusterAndEventsPresent = true
                listOfClusters = [String](clusters.keys)
                noInternetForClusters = false
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "clusterandeventsdataobtained"), object: nil)
                
            }
            
        }})
    
    task.resume()
}

//Schedule Variables
var isSchedulePresent: Bool = false
var scheduleData: Data = Data()

//Updates Variables
var updates: [[String: String]] = [["eventName":"Terribly Tiny Tales", "first": "Opal", "second": "Coral", "third": "Agate, Diamond"], ["eventName":"Counter Strike - GO", "first": "Agate", "second": "Diamond", "third": "Jade"], ["eventName":"FIFA", "first": "Jade", "second": "Coral", "third": "Agate"], ["eventName":"Mini Militia", "first": "Coral", "second": "Agate", "third": "Agate"], ["eventName":"Shoot at Sight", "first": "Coral", "second": "Coral", "third": "Coral, Diamond"]]

let firstPlaceGoldColor = UIColor(colorLiteralRed: 0.812, green: 0.71, blue: 0.231, alpha: 1)
let secondPlaceSilverColor = UIColor(red: 0.902, green: 0.91, blue: 0.98, alpha: 1)
let thirdPlaceBronzeColor = UIColor(red: 0.702, green: 0.604, blue: 0.42, alpha: 1)
let updateTileBaseColor = UIColor(red: 0.255, green: 0.345, blue: 0.424, alpha: 1)
