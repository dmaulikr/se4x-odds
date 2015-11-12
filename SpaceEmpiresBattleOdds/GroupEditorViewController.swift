//
//  GroupEditorViewController.swift
//  SpaceEmpiresBattleOdds
//
//  Created by Tibor Grose on 11/6/15.
//  Copyright © 2015 Tibor Grose. All rights reserved.
//

import UIKit

class GroupEditorViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var deleteGroupButton: UIButton!
    @IBOutlet weak var addGroupButton: UIButton!
    @IBOutlet weak var unitClassPicker: UIPickerView!
    @IBOutlet weak var attackTechPicker: UISegmentedControl!
    @IBOutlet weak var defenseTechPicker: UISegmentedControl!
    @IBOutlet weak var tacticsTechPicker: UISegmentedControl!
    @IBOutlet weak var moveTechPicker: UISegmentedControl!
    @IBOutlet weak var groupSizeField: UITextField!
    @IBOutlet weak var groupSizeIncrementer: UIStepper!
    
    var player: Player = Player.attacker
    var group: UnitGroup?
    var unitClassPickerTitles = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        unitClassPicker.delegate = self
        unitClassPicker.dataSource = self
        groupSizeIncrementer.addTarget(self, action: "groupSizeChanged", forControlEvents: UIControlEvents.ValueChanged)
        
        initClassPickerData()
        if group == nil {
            displayDefault()
        } else {
            displaySelectedGroup()
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func isEditingExistingGroup() -> Bool {
        return group != nil
    }
    
    func initClassPickerData() {
        for className in UnitClass.allClasses {
            let fullName = className.fullName()
            let attack = String(className.stats().attack)
            let defense = String(className.stats().defense)
            let hull = String(className.stats().hullStrength)
            var initGrade: String
            switch className.stats().initiative {
            case 0:
                initGrade = "A"
            case 1:
                initGrade = "B"
            case 2:
                initGrade = "C"
            case 3:
                initGrade = "D"
            case 4:
                initGrade = "E"
            default:
                initGrade = "undefined"
            }
            
            let titleString = "\(fullName) \(attack)-\(defense)x\(hull) \(initGrade)"
            unitClassPickerTitles.append(titleString)
        }
    }
    
    func groupSizeChanged() {
        groupSizeField.text = "\(Int(groupSizeIncrementer.value))"
    }
    
    func displayDefault() {
        groupSizeField.text = "\(Int(groupSizeIncrementer.value))"
    }
    
    func displaySelectedGroup() {
        addGroupButton.setTitle("Update Group", forState: UIControlState.Normal)
        groupSizeIncrementer.value = Double(group!.units.count)
        groupSizeChanged()
        
        unitClassPicker.selectRow(group!.unitType.rawValue, inComponent: 0, animated: false)
        self.pickerView(unitClassPicker, didSelectRow: group!.unitType.rawValue, inComponent: 0)
        
        attackTechPicker.selectedSegmentIndex = group!.attackTech
        defenseTechPicker.selectedSegmentIndex = group!.defenseTech
        tacticsTechPicker.selectedSegmentIndex = group!.taticTech
        moveTechPicker.selectedSegmentIndex = group!.moveTech
    }
    
    // MARK: - UIPickerViewDelegate
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return unitClassPickerTitles.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return unitClassPickerTitles[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // refresh the tech level buttons to enforce max tech levels
        let unitClass = UnitClass.allClasses[row]
        let maxTech = unitClass.stats().hullStrength
        updateTechLevelPickersForMaxLevel(maxTech)
    }
    
    func updateTechLevelPickersForMaxLevel(maxLevel: Int) {
        
        if attackTechPicker.selectedSegmentIndex > maxLevel {
            attackTechPicker.selectedSegmentIndex = maxLevel
        }
        
        if defenseTechPicker.selectedSegmentIndex > maxLevel {
            defenseTechPicker.selectedSegmentIndex = maxLevel
        }
        
        for index in 0...3 {
            let enableTech = index <= maxLevel
            attackTechPicker.setEnabled(enableTech, forSegmentAtIndex: index)
            defenseTechPicker.setEnabled(enableTech, forSegmentAtIndex: index)
        }
        
        
    }
    
    func commitChanges() {
        let newAttackTech = attackTechPicker.selectedSegmentIndex
        let newDefenseTech = defenseTechPicker.selectedSegmentIndex
        let newTacticTech = tacticsTechPicker.selectedSegmentIndex
        let newMoveTech = moveTechPicker.selectedSegmentIndex
        let newUnitClass = UnitClass.allClasses[unitClassPicker.selectedRowInComponent(0)]
        let newGroupSize = Int(groupSizeIncrementer.value)
        if group != nil {
            // commit new values to group we were passed in
            group!.unitType = newUnitClass
            group!.attackTech = newAttackTech
            group!.defenseTech = newDefenseTech
            group!.taticTech = newTacticTech
            group!.moveTech = newMoveTech
            group!.setGroupSizeTo(newGroupSize)
            
        } else {
            // we were not modifying an existing group, create a new group
            group = UnitGroup(unitClass: newUnitClass, groupSize: newGroupSize)
            group!.attackTech = newAttackTech
            group!.defenseTech = newDefenseTech
            group!.taticTech = newTacticTech
            group!.moveTech = newMoveTech
            group!.setGroupSizeTo(newGroupSize)
            PlayerFleetStore.sharedInstance.addGroupToPlayer(player, newGroup: group!)
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if let segueID = segue.identifier {
            if segueID == "commitGroupEditorChanges" {
                commitChanges()
            }
        }
    }
    

}
