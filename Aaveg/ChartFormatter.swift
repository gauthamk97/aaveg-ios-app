//
//  ChartFormatter.swift
//  Aaveg
//
//  Created by Farina Balkish A on 12/12/16.
//  Copyright © 2016 Gautham Kumar. All rights reserved.
//

import Foundation
import Charts

@objc(BarChartFormatter)
class ChartFormatter:NSObject,IAxisValueFormatter{
    
    var months: [String]! = ["Diamond", "Coral", "Jade", "Agate", "Opal"]
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return months[Int(value)]
    }
    
}
