//
//  ScoreboardViewController.swift
//  Aaveg
//
//  Created by Gautham Kumar on 06/12/16.
//  Copyright © 2016 Gautham Kumar. All rights reserved.
//

import UIKit
import Charts

class ScoreboardViewController: UIViewController {

    @IBOutlet weak var cupNameLabel: UILabel!
    var pageIndex: Int!
    var CupName: String!
    
    @IBOutlet weak var scoreboardGraphView: BarChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        UIApplication.shared.statusBarStyle = .lightContent
        self.view.backgroundColor = pageControlBGColor
        
        cupNameLabel.layer.addBorder(edge: .bottom, color: .gray, thickness: 1)
        
        //Setting up graph
        self.scoreboardGraphView.backgroundColor = pageControlBGColor
        let hostelNames = ["Diamond", "Coral", "Jade", "Agate", "Opal"]
        let hostelPoints: [Double] = [10,5,13,25,2]
        setChart(xEntries: hostelNames, yEntries: hostelPoints)
        
        title = self.CupName
        cupNameLabel.text = self.CupName
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setChart(xEntries: [String], yEntries: [Double]) {
        
        var dataEntries: [BarChartDataEntry] = []
        for i in 0..<xEntries.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: yEntries[i])
            dataEntries.append(dataEntry)
        }
    
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "Points")
        chartDataSet.colors = [diamondColor, coralColor, jadeColor, agateColor, opalColor]
        let chartData = BarChartData(dataSets: [chartDataSet])
        
        scoreboardGraphView.leftAxis.drawGridLinesEnabled = false //Removes horizontal lines
        scoreboardGraphView.leftAxis.labelTextColor = UIColor.gray //Sets labels on left axis to white color
        scoreboardGraphView.leftAxis.axisLineColor = UIColor.black //Sets left axis to white color
        
        scoreboardGraphView.xAxis.labelPosition = .bottom //Pushes x axis to bottom
        scoreboardGraphView.xAxis.drawGridLinesEnabled = false  //Removes vertical lines cutting the bars
        scoreboardGraphView.xAxis.labelTextColor = UIColor.gray //Sets labels on x axis to white color
        scoreboardGraphView.xAxis.axisLineColor = UIColor.black //sets x axis to white color
        
        scoreboardGraphView.rightAxis.drawGridLinesEnabled = false //Removes horizontal lines
        scoreboardGraphView.rightAxis.drawAxisLineEnabled = false
        scoreboardGraphView.rightAxis.drawLabelsEnabled = false
        
        scoreboardGraphView.chartDescription?.text = ""
        scoreboardGraphView.legend.enabled = false
        
        scoreboardGraphView.data = chartData
        
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

extension CALayer {
    
    func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
        
        let border = CALayer()
        print(self.frame.height)
        print(UIScreen.main.bounds.width)
        switch edge {
        case UIRectEdge.top:
            border.frame = CGRect(x: 0, y: 0, width: thickness, height: self.frame.height)
            break
        case UIRectEdge.bottom:
            border.frame = CGRect(x: 0, y: 50 - thickness, width: UIScreen.main.bounds.width, height: thickness)
            break
        case UIRectEdge.left:
            border.frame = CGRect(x: 0, y: 0, width: thickness, height: self.frame.height)
            break
        case UIRectEdge.right:
            border.frame = CGRect(x: self.frame.width - thickness, y: 0, width: thickness, height: self.frame.height)
            break
        default:
            break
        }
        
        border.backgroundColor = color.cgColor;
        
        self.addSublayer(border)
    }
    
}
