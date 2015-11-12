//
//  UnitGroupTableViewCell.swift
//  SpaceEmpiresBattleOdds
//
//  Created by Tibor Grose on 11/2/15.
//  Copyright © 2015 Tibor Grose. All rights reserved.
//

import UIKit

class UnitGroupTableViewCell: UITableViewCell {

    @IBOutlet weak var UnitClassLabel: UILabel!
    @IBOutlet weak var UnitStatsLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        UnitClassLabel.text = ""
        UnitStatsLabel.text = ""
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
