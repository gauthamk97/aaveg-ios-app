//
//  CulturalsCupViewController.swift
//  Aaveg
//
//  Created by Gautham Kumar on 08/12/16.
//  Copyright © 2016 Gautham Kumar. All rights reserved.
//

import UIKit
import Charts

class CulturalsCupViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableheightConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scoreboardGraphView: BarChartView!
    @IBOutlet weak var eventsTable: UITableView!
    
    var numberOfRows: Int = 15
    let rowHeight: CGFloat = 1110/25
    var Culttotals: [Double] = [0,0,0,0,0]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("VC1 - ViewdidLoad")
        
        eventsTable.delegate = self
        eventsTable.dataSource = self
        
        //Obtaining data
        obtainScoreboardData()
        culturalEvents.removeAll(keepingCapacity: false)
        while (culturalEvents.isEmpty) {
            continue
        }
        print("Main - \(culturalEvents)")
        
        //Setting table height according to number of events
        numberOfRows = culturalEvents.count+2 //1 is added for header row. 1 is added for total
        tableheightConstraint.constant = rowHeight*CGFloat(numberOfRows)
        
        //Setting chart details
        setChart()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let hostelNames = ["Diamond", "Coral", "Jade", "Agate", "Opal"]
        let hostelPoints: [Double] = [25,3,10,2,5]
        setChartValues(xEntries: hostelNames, yEntries: hostelPoints)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        let hostelNames = ["Diamond", "Coral", "Jade", "Agate", "Opal"]
        let hostelPoints: [Double] = [0,0,0,0,0]
        setChartValues(xEntries: hostelNames, yEntries: hostelPoints)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return culturalEvents.count+2
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventscell") as! TableViewCell
        
        if indexPath.row == 0 {
            cell.colHeader.text = "Event Name"
            cell.col1.text = "Diamond"
            cell.col2.text = "Coral"
            cell.col3.text = "Jade"
            cell.col4.text = "Agate"
            cell.col5.text = "Opal"
            
            cell.colHeader.font = UIFont.boldSystemFont(ofSize: 13)
            cell.col1.font = UIFont.boldSystemFont(ofSize: 13)
            cell.col2.font = UIFont.boldSystemFont(ofSize: 13)
            cell.col3.font = UIFont.boldSystemFont(ofSize: 13)
            cell.col4.font = UIFont.boldSystemFont(ofSize: 13)
            cell.col5.font = UIFont.boldSystemFont(ofSize: 13)
            
        }
            
        else if indexPath.row == culturalEvents.count+1 {
            cell.colHeader.text = "Total"
            
            if (Culttotals[0].truncatingRemainder(dividingBy: 1) == 0) {
                cell.col1.text = "\(Int(Culttotals[0]))"
            }
            else {
                cell.col1.text = "\(Culttotals[0])"
            }
            
            if (Culttotals[1].truncatingRemainder(dividingBy: 1) == 0) {
                cell.col2.text = "\(Int(Culttotals[1]))"
            }
            else {
                cell.col2.text = "\(Culttotals[1])"
            }
            
            if (Culttotals[2].truncatingRemainder(dividingBy: 1) == 0) {
                cell.col3.text = "\(Int(Culttotals[2]))"
            }
            else {
                cell.col3.text = "\(Culttotals[2])"
            }
            
            if (Culttotals[3].truncatingRemainder(dividingBy: 1) == 0) {
                cell.col4.text = "\(Int(Culttotals[3]))"
            }
            else {
                cell.col4.text = "\(Culttotals[3])"
            }
            
            if (Culttotals[4].truncatingRemainder(dividingBy: 1) == 0) {
                cell.col5.text = "\(Int(Culttotals[4]))"
            }
            else {
                cell.col5.text = "\(Culttotals[4])"
            }
            
            cell.colHeader.font = UIFont.boldSystemFont(ofSize: 13)
            cell.col1.font = UIFont.boldSystemFont(ofSize: 13)
            cell.col2.font = UIFont.boldSystemFont(ofSize: 13)
            cell.col3.font = UIFont.boldSystemFont(ofSize: 13)
            cell.col4.font = UIFont.boldSystemFont(ofSize: 13)
            cell.col5.font = UIFont.boldSystemFont(ofSize: 13)
            
            print("Setting totals")
            
//            let hostelNames = ["Diamond", "Coral", "Jade", "Agate", "Opal"]
//            setChartValues(xEntries: hostelNames, yEntries: Culttotals)
        }
            
        else {
            cell.colHeader.text = culturalEvents[indexPath.row-1]["event_name"] as? String
            
            let dscoreFloat = Float.init((culturalEvents[indexPath.row-1]["diamond_score"] as? String)!)!
            cell.col1.text = "\(dscoreFloat)"
            Culttotals[0] += Double(dscoreFloat)
            if (dscoreFloat.truncatingRemainder(dividingBy: 1) == 0) {
                let dscoreInt = Int(Float.init((culturalEvents[indexPath.row-1]["diamond_score"] as? String)!)!)
                cell.col1.text = "\(dscoreInt)"
            }
            
            let cscoreFloat = Float.init((culturalEvents[indexPath.row-1]["coral_score"] as? String)!)!
            cell.col2.text = "\(cscoreFloat)"
            Culttotals[1] += Double(cscoreFloat)
            if (cscoreFloat.truncatingRemainder(dividingBy: 1) == 0) {
                let cscoreInt = Int(Float.init((culturalEvents[indexPath.row-1]["coral_score"] as? String)!)!)
                cell.col2.text = "\(cscoreInt)"
            }
            
            let jscoreFloat = Float.init((culturalEvents[indexPath.row-1]["jade_score"] as? String)!)!
            cell.col3.text = "\(jscoreFloat)"
            Culttotals[2] += Double(jscoreFloat)
            if (jscoreFloat.truncatingRemainder(dividingBy: 1) == 0) {
                let jscoreInt = Int(Float.init((culturalEvents[indexPath.row-1]["jade_score"] as? String)!)!)
                cell.col3.text = "\(jscoreInt)"
            }
            
            let ascoreFloat = Float.init((culturalEvents[indexPath.row-1]["agate_score"] as? String)!)!
            cell.col4.text = "\(ascoreFloat)"
            Culttotals[3] += Double(ascoreFloat)
            if (ascoreFloat.truncatingRemainder(dividingBy: 1) == 0) {
                let ascoreInt = Int(Float.init((culturalEvents[indexPath.row-1]["agate_score"] as? String)!)!)
                cell.col4.text = "\(ascoreInt)"
            }
            
            let oscoreFloat = Float.init((culturalEvents[indexPath.row-1]["opal_score"] as? String)!)!
            cell.col5.text = "\(oscoreFloat)"
            Culttotals[4] += Double(oscoreFloat)
            if (oscoreFloat.truncatingRemainder(dividingBy: 1) == 0) {
                let oscoreInt = Int(Float.init((culturalEvents[indexPath.row-1]["opal_score"] as? String)!)!)
                cell.col5.text = "\(oscoreInt)"
            }
            
        }
        
        return cell
    }
    
    func setChart() {
        
        scoreboardGraphView.leftAxis.drawGridLinesEnabled = false //Removes horizontal lines
        scoreboardGraphView.leftAxis.labelTextColor = UIColor.gray //Sets labels on left axis to white color
        scoreboardGraphView.leftAxis.axisLineColor = UIColor.black //Sets left axis to white color
        
        scoreboardGraphView.xAxis.labelPosition = .bottom //Pushes x axis to bottom
        scoreboardGraphView.xAxis.drawGridLinesEnabled = false  //Removes vertical lines cutting the bars
        scoreboardGraphView.xAxis.labelTextColor = UIColor.gray //Sets labels on x axis to white color
        scoreboardGraphView.xAxis.axisLineColor = UIColor.black //sets x axis to white color
        
        scoreboardGraphView.rightAxis.drawGridLinesEnabled = false //Removes horizontal lines
        scoreboardGraphView.rightAxis.drawAxisLineEnabled = false //Removes right axis
        scoreboardGraphView.rightAxis.drawLabelsEnabled = false //Removes right axis' labels
        
        scoreboardGraphView.chartDescription?.text = ""
        scoreboardGraphView.legend.enabled = false
        
//        scoreboardGraphView.animate(yAxisDuration: 1, easingOption: .easeInBack)
        
    }
    
    func setChartValues(xEntries: [String], yEntries: [Double]) {
        
        var dataEntries: [BarChartDataEntry] = []
        for i in 0..<xEntries.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: yEntries[i])
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "Points")
        chartDataSet.colors = [diamondColor, coralColor, jadeColor, agateColor, opalColor]
        let chartData = BarChartData(dataSets: [chartDataSet])
        
        scoreboardGraphView.data = chartData
//        scoreboardGraphView.animate(yAxisDuration: 1, easingOption: .easeInBack)
        
    }
    
    
    
}
