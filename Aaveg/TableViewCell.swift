//
//  TableViewCell.swift
//  Aaveg
//
//  Created by Gautham Kumar on 08/12/16.
//  Copyright © 2016 Gautham Kumar. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var colHeader: UILabel!
    @IBOutlet weak var col1: UILabel!
    @IBOutlet weak var col2: UILabel!
    @IBOutlet weak var col3: UILabel!
    @IBOutlet weak var col4: UILabel!
    @IBOutlet weak var col5: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
