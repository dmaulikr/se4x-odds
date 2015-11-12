//
//  StrategySelectViewController.swift
//  SpaceEmpiresBattleOdds
//
//  Created by Tibor Grose on 11/12/15.
//  Copyright © 2015 Tibor Grose. All rights reserved.
//

import UIKit

enum StratTableSection: Int {
    case targetPriority = 0, screeningStrategy
}

class StrategySelectViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var strategySelectTableView: UITableView!
    
    var player = Player.attacker

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        strategySelectTableView.delegate = self
        strategySelectTableView.dataSource = self
        
        dismissButton.addTarget(self, action: "commitChanges", forControlEvents: UIControlEvents.TouchUpInside)
        
        titleLabel.text = player == Player.attacker ? "Choose Attacker's Strategy" : "Choose Defender's Strategy"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func commitChanges() {
        self.dismissViewControllerAnimated(true) { () -> Void in
            
        }
    }
    
    // TableView Protocol
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        /*switch section {
        case StratTableSection.targetPriority.rawValue:
            return TargetPriorityStrategy.allStrategies.count
        case StratTableSection.screeningStrategy.rawValue:
            return 1
            }
        }*/
        return TargetPriorityStrategy.allStrategies.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("StratSelectCell", forIndexPath: indexPath) as! StrategyTableViewCell
        var stratDescription: String?
        let currentTargetStrat = SimSettings.sharedInstance.targetStrategyForPlayer(player)
        let currentScreeningStrat = SimSettings.sharedInstance.screeningStrategyForPlayer(player)
        
        // Determine which section the cell is in and determine the text and selected state
        if indexPath.section == StratTableSection.targetPriority.rawValue {
            stratDescription = TargetPriorityStrategy(rawValue: indexPath.row)?.description()
            if indexPath.row == currentTargetStrat.rawValue {
                tableView.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: UITableViewScrollPosition.None)
            }
        } else {
            stratDescription = ScreeningStrategy(rawValue: indexPath.row)?.description()
            if indexPath.row == currentScreeningStrat.rawValue {
                tableView.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: UITableViewScrollPosition.None)
            }
        }
        
        if stratDescription != nil {
            cell.descriptionLabel.text = stratDescription!
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let title = section == StratTableSection.targetPriority.rawValue ? "Target Priority Strategy" : "Screening Strategy"
        
        return title
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // allow only one selection per section
        let currentTargetStrat = SimSettings.sharedInstance.targetStrategyForPlayer(player)
        let currentScreeningStrat = SimSettings.sharedInstance.screeningStrategyForPlayer(player)
        
        // If the just selected cell is in the Target section and is different from the current selection...
        if (indexPath.section == StratTableSection.targetPriority.rawValue) && (indexPath.row != currentTargetStrat.rawValue) {
            tableView.deselectRowAtIndexPath(NSIndexPath(forRow: currentTargetStrat.rawValue, inSection: indexPath.section), animated: true)
            
            // update stored value for target strategy
            SimSettings.sharedInstance.setTargetStrategyForPlayer(player, strategy: TargetPriorityStrategy(rawValue: indexPath.row)!)
        }
        
        // If the just selected cell is in the Screening section and is different from the current selection...
        if (indexPath.section == StratTableSection.screeningStrategy.rawValue) && (indexPath.row != currentScreeningStrat.rawValue) {
            tableView.deselectRowAtIndexPath(NSIndexPath(forRow: currentScreeningStrat.rawValue, inSection: indexPath.section), animated: true)
            
            // update stored value for screening strategy
            SimSettings.sharedInstance.setScreeningStrategyForPlayer(player, strategy: ScreeningStrategy(rawValue: indexPath.row)!)
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
