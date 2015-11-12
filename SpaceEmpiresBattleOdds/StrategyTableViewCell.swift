//
//  StrategyTableViewCell.swift
//  SpaceEmpiresBattleOdds
//
//  Created by Tibor Grose on 11/12/15.
//  Copyright © 2015 Tibor Grose. All rights reserved.
//

import UIKit

class StrategyTableViewCell: UITableViewCell {

    //@IBOutlet weak var isActiveSwitch: UISwitch!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
