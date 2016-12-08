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
    
    let numberOfRows: Int = 15
    let rowHeight: CGFloat = 1110/25
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("VC1 - ViewdidLoad")
        
        eventsTable.delegate = self
        eventsTable.dataSource = self
        
        //Setting table height according to number of events
        tableheightConstraint.constant = rowHeight*CGFloat(numberOfRows)
        
        //Setting chart details
        setChart()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let hostelNames = ["Diamond", "Coral", "Jade", "Agate", "Opal"]
        let hostelPoints: [Double] = [10,5,13,25,2]
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
        return numberOfRows
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
            
        else {
            cell.colHeader.text = "Event Number \(indexPath.row)"
            cell.col1.text = "10"
            cell.col2.text = "5"
            cell.col3.text = "15"
            cell.col4.text = "5"
            cell.col5.text = "10"
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
        
        scoreboardGraphView.animate(yAxisDuration: 1.1, easingOption: .easeInBack)
        
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
        scoreboardGraphView.animate(yAxisDuration: 1, easingOption: .easeInBack)
        
    }
}
