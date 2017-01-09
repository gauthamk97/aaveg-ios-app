//
//  SpectrumCupViewController.swift
//  Aaveg
//
//  Created by Gautham Kumar on 08/12/16.
//  Copyright © 2016 Gautham Kumar. All rights reserved.
//

import UIKit
import Charts

class SpectrumCupViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableheightConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scoreboardGraphView: BarChartView!
    @IBOutlet weak var eventsTable: UITableView!
    
    var numberOfRows: Int = 15
    let rowHeight: CGFloat = 1110/25
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.onrefresh), for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.white
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Spectrum Cup View Loaded")
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.dataObtained), name: NSNotification.Name(rawValue: "3stcupdataobtained"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.obtainingData), name: NSNotification.Name(rawValue: "obtaining3stcupdata"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.noInternet), name: NSNotification.Name(rawValue: "nointernet"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.serverError), name: NSNotification.Name(rawValue: "servererror"), object: nil)
        
        eventsTable.delegate = self
        eventsTable.dataSource = self
        self.scrollView.addSubview(refreshControl)
        self.scrollView.alwaysBounceVertical = true
        
        //Obtaining data
        if SpectrumCupDataPresent == true {
            self.dataObtained()
        }
        
        //Setting table height according to number of events
        if SpectrumCupDataPresent == true && isInternetPresent {
            numberOfRows = spectrumEvents.count+2 //1 is added for header row. 1 is added for total
        }
        else {
            numberOfRows = 1
        }
        
        tableheightConstraint.constant = rowHeight*CGFloat(numberOfRows)
        
        //Setting chart details
        setChart()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if SpectrumCupDataPresent && isInternetPresent {
            setChartValues(xEntries: hostelNames, yEntries: spectrumCupTotals)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        currentScoreboardPage = 3
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        let hostelPoints: [Double] = [0,0,0,0,0]
        if isInternetPresent {
            setChartValues(xEntries: hostelNames, yEntries: hostelPoints)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableheightConstraint.constant = rowHeight*CGFloat(numberOfRows)
        return numberOfRows
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventscell") as! TableViewCell
        cell.selectionStyle = .none
        
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
            
        else if indexPath.row == spectrumEvents.count+1 {
            cell.colHeader.text = "Total"
            
            if (spectrumCupTotals[0].truncatingRemainder(dividingBy: 1) == 0) {
                cell.col1.text = "\(Int(spectrumCupTotals[0]))"
            }
            else {
                cell.col1.text = "\(spectrumCupTotals[0])"
            }
            
            if (spectrumCupTotals[1].truncatingRemainder(dividingBy: 1) == 0) {
                cell.col2.text = "\(Int(spectrumCupTotals[1]))"
            }
            else {
                cell.col2.text = "\(spectrumCupTotals[1])"
            }
            
            if (spectrumCupTotals[2].truncatingRemainder(dividingBy: 1) == 0) {
                cell.col3.text = "\(Int(spectrumCupTotals[2]))"
            }
            else {
                cell.col3.text = "\(spectrumCupTotals[2])"
            }
            
            if (spectrumCupTotals[3].truncatingRemainder(dividingBy: 1) == 0) {
                cell.col4.text = "\(Int(spectrumCupTotals[3]))"
            }
            else {
                cell.col4.text = "\(spectrumCupTotals[3])"
            }
            
            if (spectrumCupTotals[4].truncatingRemainder(dividingBy: 1) == 0) {
                cell.col5.text = "\(Int(spectrumCupTotals[4]))"
            }
            else {
                cell.col5.text = "\(spectrumCupTotals[4])"
            }
            
            cell.colHeader.font = UIFont.boldSystemFont(ofSize: 13)
            cell.col1.font = UIFont.boldSystemFont(ofSize: 13)
            cell.col2.font = UIFont.boldSystemFont(ofSize: 13)
            cell.col3.font = UIFont.boldSystemFont(ofSize: 13)
            cell.col4.font = UIFont.boldSystemFont(ofSize: 13)
            cell.col5.font = UIFont.boldSystemFont(ofSize: 13)
            
        }
            
        else {
            cell.colHeader.text = spectrumEvents[indexPath.row-1]["event_name"] as? String
            
            let dscoreFloat = Float.init((spectrumEvents[indexPath.row-1]["diamond_score"] as? String)!)!
            cell.col1.text = "\(dscoreFloat)"
            
            if (dscoreFloat.truncatingRemainder(dividingBy: 1) == 0) {
                let dscoreInt = Int(Float.init((spectrumEvents[indexPath.row-1]["diamond_score"] as? String)!)!)
                cell.col1.text = "\(dscoreInt)"
            }
            
            let cscoreFloat = Float.init((spectrumEvents[indexPath.row-1]["coral_score"] as? String)!)!
            cell.col2.text = "\(cscoreFloat)"
            
            if (cscoreFloat.truncatingRemainder(dividingBy: 1) == 0) {
                let cscoreInt = Int(Float.init((spectrumEvents[indexPath.row-1]["coral_score"] as? String)!)!)
                cell.col2.text = "\(cscoreInt)"
            }
            
            let jscoreFloat = Float.init((spectrumEvents[indexPath.row-1]["jade_score"] as? String)!)!
            cell.col3.text = "\(jscoreFloat)"
            
            if (jscoreFloat.truncatingRemainder(dividingBy: 1) == 0) {
                let jscoreInt = Int(Float.init((spectrumEvents[indexPath.row-1]["jade_score"] as? String)!)!)
                cell.col3.text = "\(jscoreInt)"
            }
            
            let ascoreFloat = Float.init((spectrumEvents[indexPath.row-1]["agate_score"] as? String)!)!
            cell.col4.text = "\(ascoreFloat)"
            
            if (ascoreFloat.truncatingRemainder(dividingBy: 1) == 0) {
                let ascoreInt = Int(Float.init((spectrumEvents[indexPath.row-1]["agate_score"] as? String)!)!)
                cell.col4.text = "\(ascoreInt)"
            }
            
            let oscoreFloat = Float.init((spectrumEvents[indexPath.row-1]["opal_score"] as? String)!)!
            cell.col5.text = "\(oscoreFloat)"
            
            if (oscoreFloat.truncatingRemainder(dividingBy: 1) == 0) {
                let oscoreInt = Int(Float.init((spectrumEvents[indexPath.row-1]["opal_score"] as? String)!)!)
                cell.col5.text = "\(oscoreInt)"
            }
            
        }
        
        return cell

    }
    
    func setChart() {
        
        scoreboardGraphView.leftAxis.drawGridLinesEnabled = false //Removes horizontal lines
        scoreboardGraphView.leftAxis.labelTextColor = UIColor.white //Sets labels on left axis to white color
        scoreboardGraphView.leftAxis.axisLineColor = UIColor.black //Sets left axis to black color
        
        scoreboardGraphView.xAxis.labelPosition = .bottom //Pushes x axis to bottom
        scoreboardGraphView.xAxis.drawGridLinesEnabled = false  //Removes vertical lines cutting the bars
        scoreboardGraphView.xAxis.labelTextColor = UIColor.white //Sets labels on x axis to white color
        scoreboardGraphView.xAxis.axisLineColor = UIColor.black //sets x axis to black color
        
        scoreboardGraphView.rightAxis.drawGridLinesEnabled = false //Removes horizontal lines
        scoreboardGraphView.rightAxis.drawAxisLineEnabled = false //Removes right axis
        scoreboardGraphView.rightAxis.drawLabelsEnabled = false //Removes right axis' labels
        
        scoreboardGraphView.chartDescription?.text = ""
        scoreboardGraphView.legend.enabled = false
        scoreboardGraphView.noDataText = "Obtaining Data"
        scoreboardGraphView.noDataTextColor = UIColor.white
        
        scoreboardGraphView.isUserInteractionEnabled = false //Prevents touch inputs to graph view
        
        scoreboardGraphView.leftAxis.axisMinimum = 0  //Prevents gap at bottom for lower scores
        
        //Setting x axis labels as hostel names
        scoreboardGraphView.xAxis.granularityEnabled = true
        scoreboardGraphView.xAxis.granularity = 1
        
        let xAxis=XAxis()
        let chartFormmater=ChartFormatter()
        
        for i in 0...4{
            chartFormmater.stringForValue(Double(i), axis: xAxis)
        }
        
        xAxis.valueFormatter=chartFormmater
        scoreboardGraphView.xAxis.valueFormatter=xAxis.valueFormatter
        
    }
    
    func setChartValues(xEntries: [String], yEntries: [Double]) {
        
        var dataEntries: [BarChartDataEntry] = []
        for i in 0..<xEntries.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: yEntries[i])
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "Points")
        chartDataSet.colors = [diamondColor, coralColor, jadeColor, agateColor, opalColor] //Sets color of bars
        chartDataSet.valueColors = [UIColor.white as NSUIColor] //Sets color of labels on top of bars
        let chartData = BarChartData(dataSets: [chartDataSet])
        
        scoreboardGraphView.data = chartData
        scoreboardGraphView.animate(yAxisDuration: 1, easingOption: .easeInBack)
        scoreboardGraphView.notifyDataSetChanged()
        
    }
    
    func dataObtained() {
        
        for i in 0...4 {
            spectrumCupTotals[i] = 0
        }
        
        for item in spectrumEvents {
            spectrumCupTotals[0] += Double.init((item["diamond_score"] as? String)!)!
            spectrumCupTotals[1] += Double.init((item["coral_score"] as? String)!)!
            spectrumCupTotals[2] += Double.init((item["jade_score"] as? String)!)!
            spectrumCupTotals[3] += Double.init((item["agate_score"] as? String)!)!
            spectrumCupTotals[4] += Double.init((item["opal_score"] as? String)!)!
        }
        
        setChartValues(xEntries: hostelNames, yEntries: spectrumCupTotals)
        
        DispatchQueue.main.async{
            self.eventsTable.reloadData()
            if self.refreshControl.isRefreshing {
                self.refreshControl.endRefreshing()
            }
        }
        
        isObtainingSpectrumCupData = false
        SpectrumCupDataPresent = true
        numberOfRows = spectrumEvents.count+2
        
        print("Spectrum cup data obtained")
    }
    
    func onrefresh(sender: UIRefreshControl) {
        if isObtainingSpectrumCupData {
            if refreshControl.isRefreshing {
                refreshControl.endRefreshing()
            }
            return
        }
        obtainScoreboardData(index: 3)
    }
    
    func obtainingData() {
        isObtainingSpectrumCupData = true
        SpectrumCupDataPresent = false
        scoreboardGraphView.data = nil
        scoreboardGraphView.noDataText = "Obtaining Data"
        scoreboardGraphView.notifyDataSetChanged()
    }
    
    func noInternet() {
        isObtainingSpectrumCupData = false
        scoreboardGraphView.data = nil
        scoreboardGraphView.noDataText = "No Internet"
        scoreboardGraphView.notifyDataSetChanged()
        DispatchQueue.main.async {
            if self.refreshControl.isRefreshing {
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    func serverError() {
        isObtainingSpectrumCupData = false
        scoreboardGraphView.noDataText = "Server Error"
        scoreboardGraphView.data = nil
        scoreboardGraphView.notifyDataSetChanged()
    }
}
