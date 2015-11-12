//
//  UnitGroup.swift
//  SpaceEmpiresBattleOdds
//
//  Created by Tibor Grose on 11/2/15.
//  Copyright © 2015 Tibor Grose. All rights reserved.
//

import Foundation

func == (lhs: UnitGroup, rhs: UnitGroup) -> Bool {
    return lhs.hashValue == rhs.hashValue
}

class UnitGroup: Hashable {
    private var _groupSize = 0
    private var unitTemplate: Unit
    var units = Set<Unit>()
    var hashValue: Int { return unitTemplate.unitID }
    var unitType: UnitClass {
        get {
            return unitTemplate.unitType
        }
        set {
            unitTemplate.unitType = newValue
            unitTemplateModified()
        }
    }
    var attackTech: Int {
        get {
            return unitTemplate.attackTech
        }
        set {
            unitTemplate.attackTech = newValue
            unitTemplateModified()
        }
    }
    var defenseTech: Int {
        get {
            return unitTemplate.defenseTech
        }
        set {
            unitTemplate.defenseTech = newValue
            unitTemplateModified()
        }
    }
    var moveTech: Int {
        get {
            return unitTemplate.moveTech
        }
        set {
            unitTemplate.moveTech = newValue
            unitTemplateModified()
        }
    }
    var taticTech: Int {
        get {
            return unitTemplate.taticTech
        }
        set {
            unitTemplate.taticTech = newValue
            unitTemplateModified()
        }
    }
    
    init(unitClass: UnitClass, groupSize: Int) {
        self.unitTemplate = Unit(unitClass: unitClass)
        setGroupSizeTo(groupSize)
    }
    
    init(unit: Unit, groupSize: Int) {
        self.unitTemplate = unit
        setGroupSizeTo(groupSize)
    }
    
    /*func unitClass() -> UnitClass {
        return unitTemplate.unitType
    }*/
    
    func setGroupSizeTo(var newSize: Int) {
        if newSize < 1 {
            print("UnitGroup ERROR - groupSize should never be less than 1")
            newSize = 1
        }
        
        var groupSizeChange = newSize - _groupSize
        if groupSizeChange > 0 {
            // add new units
            while groupSizeChange > 0 {
                units.insert(unitTemplate.copy())
                groupSizeChange--
            }
        } else if groupSizeChange < 0 {
            // remove units
            while groupSizeChange < 0 {
                units.removeFirst()
                groupSizeChange++
            }
        }
        
        _groupSize = newSize
    }
    
    func changeUnit(newUnit: Unit) {
        // remember the current group size
        let currentGroupSize = _groupSize
        
        // reset group size to 0 and remove all members of units set
        _groupSize = 0
        units.removeAll(keepCapacity: true)
        
        // set the new unit template and rebuild the units set
        unitTemplate = newUnit
        setGroupSizeTo(currentGroupSize)
    }
    
    func unitTemplateModified() {
        for unit in units {
            unit.attackTech = unitTemplate.attackTech
            unit.defenseTech = unitTemplate.defenseTech
            unit.moveTech = unitTemplate.moveTech
            unit.taticTech = unitTemplate.taticTech
            unit.unitType = unitTemplate.unitType
        }
    }
    
    func expectedSurvialRate() -> Int {
        let simIterations = Double(SimSettings.sharedInstance.simIterations)
        var totalSurvivors = 0.0
        for unit in units {
            totalSurvivors += Double(unit.survivalCount)
        }
        
        let rate = Int(totalSurvivors / (simIterations * Double(units.count)) * 100)
        
        return rate
    }
    
    func expectedUnitsSurviving() -> Int {
        let simIterations = Double(SimSettings.sharedInstance.simIterations)
        var totalSurvivors = 0.0
        for unit in units {
            totalSurvivors += Double(unit.survivalCount)
        }
        
        let survivalRate = totalSurvivors / (simIterations * Double(units.count))
        let survivors = Int(round(Double(units.count) * survivalRate))
        
        return survivors
    }
    
    func k2dRatio() -> Double {
        var totalKills = 0
        var totalDeaths = 0
        for unit in units {
            totalKills += unit.killCount
            totalDeaths += unit.destroyedCount
        }
        
        return totalDeaths > 0 ? Double(totalKills) / Double(totalDeaths) : Double(totalKills)
    }
    
    func descriptionLabel() -> String {
        // "A 7-2 x3 A0 D0 T0 M0 12CP : 3 units"
        let num2LetterArray = ["A","B","C","D","E"]
        let initString = num2LetterArray[unitTemplate.initiativeGroup]
        let baseADString = "\(unitTemplate.baseAttack)-\(unitTemplate.baseDefense)"
        let techLevelString = "A\(unitTemplate.attackTech) D\(unitTemplate.defenseTech) T\(unitTemplate.taticTech)"
        let costString = "\(unitTemplate.econValue)CP"
        let groupSize = units.count
        let groupSizeSuffix = groupSize == 1 ? "unit" : "units"
        let groupSizeString = "\(groupSize) \(groupSizeSuffix)"
        return initString + " " + baseADString + " " + techLevelString + " " + costString + " : " + groupSizeString
    }
}