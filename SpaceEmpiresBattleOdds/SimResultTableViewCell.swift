//
//  SimResultTableViewCell.swift
//  SpaceEmpiresBattleOdds
//
//  Created by Tibor Grose on 11/10/15.
//  Copyright © 2015 Tibor Grose. All rights reserved.
//

import UIKit

class SimResultTableViewCell: UITableViewCell {
    @IBOutlet weak var groupDescriptionLabel: UILabel!

    @IBOutlet weak var survivorLabel: UILabel!
    @IBOutlet weak var kill2deathRatioLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        groupDescriptionLabel.text = ""
        kill2deathRatioLabel.text = ""
        survivorLabel.text = ""
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
