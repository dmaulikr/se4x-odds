//
//  Ship.swift
//  SpaceEmpiresBattleOdds
//
//  Created by Tibor Grose on 10/27/15.
//  Copyright © 2015 Tibor Grose. All rights reserved.
//

import Foundation

struct UnitStats {
    var econValue: Int
    var attack: Int
    var defense: Int
    var initiative: Int
    var hullStrength: Int
}

enum UnitClass: Int {
    case Base = 0, Scout, Destroyer, Cruiser, BattleCruiser, Battleship, Dreadnaught
    
    static let allClasses = [Base, Scout, Destroyer, Cruiser, BattleCruiser, Battleship, Dreadnaught]
    
    func abbreviation() -> String {
        switch self {
        case .Base:
            return "Base"
        case .Scout:
            return "SC"
        case .Destroyer:
            return "DD"
        case .Cruiser:
            return "CA"
        case .BattleCruiser:
            return "BC"
        case .Battleship:
            return "BB"
        case .Dreadnaught:
            return "DN"
        }
    }
    
    func fullName() -> String {
        switch self {
        case .Base:
            return "Base"
        case .Scout:
            return "Scout"
        case .Destroyer:
            return "Destroyer"
        case .Cruiser:
            return "Cruiser"
        case .BattleCruiser:
            return "BattleCruiser"
        case .Battleship:
            return "Battleship"
        case .Dreadnaught:
            return "Dreadnaught"
        }
    }
    
    func stats() -> UnitStats {
        switch self {
        case .Base:
            return UnitStats(econValue: 12, attack: 7, defense: 2, initiative: 0, hullStrength: 3)
        case .Scout:
            return UnitStats(econValue: 6, attack: 3, defense: 0, initiative: 4, hullStrength: 1)
        case .Destroyer:
            return UnitStats(econValue: 9, attack: 4, defense: 0, initiative: 3, hullStrength: 1)
        case .Cruiser:
            return UnitStats(econValue: 12, attack: 4, defense: 1, initiative: 2, hullStrength: 2)
        case .BattleCruiser:
            return UnitStats(econValue: 15, attack: 5, defense: 1, initiative: 1, hullStrength: 2)
        case .Battleship:
            return UnitStats(econValue: 20, attack: 5, defense: 2, initiative: 0, hullStrength: 3)
        case .Dreadnaught:
            return UnitStats(econValue: 24, attack: 6, defense: 3, initiative: 0, hullStrength: 3)
        }
    }
}

private var UNIT_SERIAL_NUMBER = 0

// Equatable function for Unit class
func == (lhs: Unit, rhs: Unit) -> Bool {
    return lhs.unitID == rhs.unitID
}

class Unit: Hashable {
    var unitID: Int
    var unitType: UnitClass {
        didSet {
            baseAttack = unitType.stats().attack
            baseDefense = unitType.stats().defense
            initiativeGroup = unitType.stats().initiative
            hullStrength = unitType.stats().hullStrength
            hullStrengthMax = hullStrength
            econValue = unitType.stats().econValue
        }
    }
    var attackTech: Int
    var defenseTech: Int
    var moveTech: Int
    var taticTech: Int
    var econValue: Int
    var baseAttack: Int
    var baseDefense: Int
    var initiativeGroup: Int
    var hullStrengthMax: Int
    var hullStrength: Int
    var isScreened: Bool
    var hasAttacked: Bool
    var isDesignatedAttacker: Bool
    var hasGroupSizeAttackBonus: Bool
    var hashValue: Int { return unitID } // Hashable protocol property
    // Stat properties
    var destroyedCount: Int // times unit was destroyed
    var killCount: Int // times unit killed target
    var survivalCount: Int // times unit survied the battle
    
    init(unitClass: UnitClass) {
        self.unitID = UNIT_SERIAL_NUMBER++ // should be unique during runtime
        self.unitType = unitClass
        self.attackTech = 0
        self.defenseTech = 0
        self.moveTech = 0
        self.taticTech = 0
        self.econValue = unitClass.stats().econValue
        self.baseAttack = unitClass.stats().attack
        self.baseDefense = unitClass.stats().defense
        self.initiativeGroup = unitClass.stats().initiative
        self.hullStrengthMax = unitClass.stats().hullStrength
        self.hullStrength = self.hullStrengthMax
        self.isScreened = false
        self.hasAttacked = false
        self.isDesignatedAttacker = false
        self.hasGroupSizeAttackBonus = false
        self.destroyedCount = 0
        self.killCount = 0
        self.survivalCount = 0
    }
    
    init(unitToCopy: Unit) {
        // Used for creating a copy of another unit
        // New unit will have a unique unitID
        self.unitID = UNIT_SERIAL_NUMBER++
        self.unitType = unitToCopy.unitType
        self.attackTech = unitToCopy.attackTech
        self.defenseTech = unitToCopy.defenseTech
        self.moveTech = unitToCopy.moveTech
        self.taticTech = unitToCopy.taticTech
        self.econValue = unitToCopy.econValue
        self.baseAttack = unitToCopy.baseAttack
        self.baseDefense = unitToCopy.baseDefense
        self.initiativeGroup = unitToCopy.initiativeGroup
        self.hullStrengthMax = unitToCopy.hullStrengthMax
        self.hullStrength = unitToCopy.hullStrength
        self.isScreened = unitToCopy.isScreened
        self.hasAttacked = unitToCopy.hasAttacked
        self.isDesignatedAttacker = unitToCopy.isDesignatedAttacker
        self.hasGroupSizeAttackBonus = unitToCopy.hasGroupSizeAttackBonus
        self.destroyedCount = 0
        self.killCount = 0
        self.survivalCount = 0
    }
    
    func copy() -> Unit {
        return Unit(unitToCopy: self)
    }
    
    func unitCombatRank() -> Int {
        return (baseAttack + attackTech + baseDefense + defenseTech + taticTech) * hullStrength
    }
    
    func isDestroyed() -> Bool {
        return hullStrength <= 0
    }
    
    func descriptionShort() -> String {
        var sideName = "D"
        if isDesignatedAttacker {
            sideName = "A"
        }
        return sideName + " " + unitType.abbreviation() + "\(unitID)"
    }
    
    func descriptionStatus() -> String {
        return unitType.abbreviation() + "\(unitID)(\(baseAttack)+\(attackTech) \(baseDefense)+\(defenseTech) x\(hullStrengthMax)/\(hullStrength))" + "K\(killCount)/D\(destroyedCount)" + " S\(survivalCount)"
    }
    
    func resetStats() {
        destroyedCount = 0
        killCount = 0
    }
    
}

