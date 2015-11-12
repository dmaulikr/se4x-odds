//
//  BattleEditorViewController.swift
//  SpaceEmpiresBattleOdds
//
//  Created by Tibor Grose on 11/2/15.
//  Copyright © 2015 Tibor Grose. All rights reserved.
//

import UIKit

let simDoneNotificationKey = "com.tiborg.SpaceEmpiresBattleOdds.simDone"

class BattleEditorViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SimSettingsDelegate {

    @IBOutlet weak var defenderScreenStratLabel: UILabel!
    @IBOutlet weak var defenderTargetStratLabel: UILabel!
    @IBOutlet weak var attackerTargetStratLabel: UILabel!
    @IBOutlet weak var attackerScreenStratLabel: UILabel!
    @IBOutlet weak var runSimButton: UIButton!
    @IBOutlet weak var DefenderTableView: UITableView!
    @IBOutlet weak var AttackerTableView: UITableView!
    @IBOutlet weak var addAttackGroupButton: UIButton!
    @IBOutlet weak var addDefenseGroupButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        AttackerTableView.delegate = self
        AttackerTableView.dataSource = self
        DefenderTableView.delegate = self
        DefenderTableView.dataSource = self
        runSimButton.addTarget(self, action: "runSim", forControlEvents: UIControlEvents.TouchUpInside)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "simDone", name: simDoneNotificationKey, object: nil)
        
        SimSettings.sharedInstance.delegate = self
        
        attackerTargetStratLabel.text = SimSettings.sharedInstance.targetStrategyForPlayer(Player.attacker).name()
        attackerScreenStratLabel.text = SimSettings.sharedInstance.screeningStrategyForPlayer(Player.attacker).name()
        defenderTargetStratLabel.text = SimSettings.sharedInstance.targetStrategyForPlayer(Player.defender).name()
        defenderScreenStratLabel.text = SimSettings.sharedInstance.screeningStrategyForPlayer(Player.defender).name()
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if let segueID = segue.identifier {
            if segueID == "showAttackerGroupEditor" {
                let groupEditor = segue.destinationViewController as! GroupEditorViewController
                groupEditor.player = Player.attacker
            }
            if segueID == "showDefenderGroupEditor" {
                let groupEditor = segue.destinationViewController as! GroupEditorViewController
                groupEditor.player = Player.defender
            }
            if segueID == "groupSelected" {
                let groupEditor = segue.destinationViewController as! GroupEditorViewController
                let group = sender as! UnitGroup
                groupEditor.player = PlayerFleetStore.sharedInstance.playerForUnitGroup(group)
                groupEditor.group = group
            }
            if segueID == "showAttackerStrategy" {
                let stratEditor = segue.destinationViewController as! StrategySelectViewController
                stratEditor.player = Player.attacker
            }
            if segueID == "showDefenderStrategy" {
                let stratEditor = segue.destinationViewController as! StrategySelectViewController
                stratEditor.player = Player.defender
            }
        }
    }
    
    
    // TableView Protocol
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rows = 0
        if tableView == AttackerTableView {
            rows = PlayerFleetStore.sharedInstance.fleetForPlayer(Player.attacker).count
        } else {
            rows = PlayerFleetStore.sharedInstance.fleetForPlayer(Player.defender).count
        }
        
        return rows
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCellWithIdentifier("UnitGroupTableViewCell", forIndexPath:  indexPath) as! UnitGroupTableViewCell
        let cell = tableView.dequeueReusableCellWithIdentifier("UnitGroupTableViewCell", forIndexPath: indexPath) as! UnitGroupTableViewCell
        var group: UnitGroup?
        
        if tableView == AttackerTableView {
            group = PlayerFleetStore.sharedInstance.unitGroupForPlayer(Player.attacker, atIndex: indexPath.row)
        } else {
            group = PlayerFleetStore.sharedInstance.unitGroupForPlayer(Player.defender, atIndex: indexPath.row)
        }
        if group != nil {
            cell.UnitClassLabel.text = group!.unitType.abbreviation()
            //cell.UnitStatsLabel.text = String(group!.units.count)
            cell.UnitStatsLabel.text = group!.descriptionLabel()
        }
        
        
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // get the UnitGroup selected and pass it to the GroupEditorViewController
        var group: UnitGroup?
        
        if tableView == AttackerTableView {
            group = PlayerFleetStore.sharedInstance.unitGroupForPlayer(Player.attacker, atIndex: indexPath.row)
        } else {
            group = PlayerFleetStore.sharedInstance.unitGroupForPlayer(Player.defender, atIndex: indexPath.row)
        }
        
        if group != nil {
            self.performSegueWithIdentifier("groupSelected", sender: group)
        }
    }
    
    func runSim() {
        PlayerFleetStore.sharedInstance.resetAllUnitStats()
        SimStats.sharedInstance.resetAll()
        
        let attackGroup = PlayerFleetStore.sharedInstance.playerGroupForPlayer(Player.attacker)
        let defendGroup = PlayerFleetStore.sharedInstance.playerGroupForPlayer(Player.defender)
        
        if attackGroup.groupSize() == 0 || defendGroup.groupSize() == 0 {
            
            let alert = UIAlertController(title: "Not Enough Combatants", message: "Attacker and Defender must have at least one group", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        let sim = CombatSimulator(attacker: attackGroup, defender: defendGroup)
        
        let iterations = SimSettings.sharedInstance.simIterations
        sim.runBattle(iterations)
        
        sim.printGroupStatus()
        SimStats.sharedInstance.attackerWins = attackGroup.winCount
        SimStats.sharedInstance.defenderWins = defendGroup.winCount
        
        let attackWinPercent = Double(attackGroup.winCount) / Double(iterations)
        let defendWinPercent = Double(defendGroup.winCount) / Double(iterations)
        print("Attacker Success Rate:\(attackWinPercent)\nDefender Success Rate:\(defendWinPercent)")
        
        NSNotificationCenter.defaultCenter().postNotificationName(simDoneNotificationKey, object: nil)
        
    }
    
    func simDone() {
        performSegueWithIdentifier("showSimResultsViewController", sender: nil)
    }
    
    // SimSettingsDelegate
    
    func targetStrategyChangedForPlayer(player: Player) {
        let newText = SimSettings.sharedInstance.targetStrategyForPlayer(player).name()
        switch player {
        case .attacker:
            attackerTargetStratLabel.text = newText
        case .defender:
            defenderTargetStratLabel.text = newText
        }
    }
    
    func screeningStrategyChangedForPlayer(player: Player) {
        let newText = SimSettings.sharedInstance.screeningStrategyForPlayer(player).name()
        switch player {
        case .attacker:
            attackerScreenStratLabel.text = newText
        case .defender:
            defenderScreenStratLabel.text = newText
        }
    }
    
    

}
