//
//  SimProgressViewController.swift
//  SpaceEmpiresBattleOdds
//
//  Created by Tibor Grose on 11/9/15.
//  Copyright © 2015 Tibor Grose. All rights reserved.
//

import UIKit

enum SimResultSection: Int {
    case attacker = 0, defender
}

class SimResultViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var winnerLabel: UILabel!
    @IBOutlet weak var resultTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        resultTableView.delegate = self
        resultTableView.dataSource = self
        dismissButton.addTarget(self, action: "simFinished", forControlEvents: UIControlEvents.TouchUpInside)
        
        winnerLabel.text = SimStats.sharedInstance.attackerWins > SimStats.sharedInstance.defenderWins ? "ATTACKER WINS" : "DEFENDER WINS"
    }
    
    override func viewWillDisappear(animated: Bool) {
        //SimSettings.sharedInstance.simIterations = Int(simIterationSlider.value)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func simFinished() {
        self.dismissViewControllerAnimated(true) { () -> Void in
            
        }
    }
    
    // TableView Protocol
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rows = 0
        if section == SimResultSection.attacker.rawValue {
            rows = PlayerFleetStore.sharedInstance.fleetForPlayer(Player.attacker).count
        } else {
            rows = PlayerFleetStore.sharedInstance.fleetForPlayer(Player.defender).count
        }
        
        return rows
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("SimResultTableViewCell", forIndexPath: indexPath) as! SimResultTableViewCell
        
        let player = indexPath.section == SimResultSection.attacker.rawValue ? Player.attacker : Player.defender
        if let group = PlayerFleetStore.sharedInstance.unitGroupForPlayer(player, atIndex: indexPath.row) {
            cell.groupDescriptionLabel.text = "\(group.unitType.abbreviation()) \(group.descriptionLabel())"
            
            
            cell.survivorLabel.text = "\(group.expectedUnitsSurviving())"
            cell.kill2deathRatioLabel.text = String(format: "%.1f", group.k2dRatio() )
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let attackerWins = SimStats.sharedInstance.attackerWins
        let defenderWins = SimStats.sharedInstance.defenderWins
        let iterations = SimSettings.sharedInstance.simIterations
        let attackWinPercent = String(format: "%.0f", Double(attackerWins) / Double(iterations) * 100.0)
        let defendWinPercent = String(format: "%.0f", Double(defenderWins) / Double(iterations) * 100.0)
        
        let titleString = section == SimResultSection.attacker.rawValue ? "Attacker Fleet Success Rate: \(attackWinPercent)%" : "Defender Fleet Success Rate: \(defendWinPercent)%"
        return titleString
    }
    

}
