//
//  PlayerGroup.swift
//  SpaceEmpiresBattleOdds
//
//  Created by Tibor Grose on 10/28/15.
//  Copyright © 2015 Tibor Grose. All rights reserved.
//

import Foundation

class PlayerGroup {
    private var units = Set<Unit>()
    var winCount = 0
    var isGroupSizeBonusEligible = false {
        didSet {
            // set all unit's size bonus flag
            for unit in units {
                unit.hasGroupSizeAttackBonus = isGroupSizeBonusEligible
            }
        }
    }
    var isDesignatedAttacker = false {
        didSet {
            for unit in units {
                unit.isDesignatedAttacker = isDesignatedAttacker
            }
        }
    }
    // attack strategy
    // screening strategy
    
    func descriptionStatus() -> String {
        var description = ""
        for unit in units {
            description += "\(unit.descriptionStatus()) "
        }
        
        return description
    }
    
    func groupSize() -> Int {
        return units.count
    }
    
    func activeGroupSize() -> Int {
        // Returns count of undestroyed units
        var activeCount = 0
        for unit in units {
            // a unit is active if it is not destroyed or screened
            if !(unit.isDestroyed() || unit.isScreened) {
                activeCount++
            }
        }
        
        return activeCount
    }
    
    func groupUnits() -> Set<Unit> {
        return units
    }
    
    func unitsOfInitGroup(groupIndex: Int) -> Set<Unit> {
        var returnSet = Set<Unit>()
        for unit in units {
            if unit.initiativeGroup == groupIndex {
                returnSet.insert(unit)
            }
        }
        
        return returnSet
    }
    
    func addUnit(newUnit: Unit) {
        newUnit.isDesignatedAttacker = isDesignatedAttacker
        units.insert(newUnit)
    }
    
    func removeUnit(unitToRemove: Unit) {
        units.remove(unitToRemove)
    }
    
    func repairUnits () {
        for unit in units {
            unit.hullStrength = unit.hullStrengthMax
        }
    }
}