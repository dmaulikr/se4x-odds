//
//  PlayerEditorController.swift
//  SpaceEmpiresBattleOdds
//
//  Created by Tibor Grose on 11/2/15.
//  Copyright © 2015 Tibor Grose. All rights reserved.
//

import Foundation

enum Player {
    case attacker, defender
}

class PlayerFleetStore {
    // This class keeps track of the groups of units for each player fleet
    // Used to provide the data source for table views in the BattleEditorViewController
    
    static let sharedInstance = PlayerFleetStore()
    private init() {}
    
    private var attackFleetArray = [UnitGroup]()
    private var defendFleetArray = [UnitGroup]()
    
    func fleetForPlayer(player: Player) -> [UnitGroup] {
        if player == Player.attacker {
            return attackFleetArray
        } else {
            return defendFleetArray
        }
    }
    
    func addGroupToPlayer(player: Player, newUnit: Unit, groupSize: Int) -> UnitGroup {
        let newGroup = UnitGroup(unit: newUnit, groupSize: groupSize)
        
        if player == Player.attacker {
            attackFleetArray.append(newGroup)
        } else {
            defendFleetArray.append(newGroup)
        }
        
        return newGroup
    }
    
    func addGroupToPlayer(player: Player, newGroup: UnitGroup) {
        if player == Player.attacker {
            attackFleetArray.append(newGroup)
        } else {
            defendFleetArray.append(newGroup)
        }
    }
    
    func unitGroupForPlayer(player: Player, atIndex: Int) -> UnitGroup? {
        if player == Player.attacker {
            return attackFleetArray[atIndex]
        } else {
            return defendFleetArray[atIndex]
        }
    }
    
    func playerForUnitGroup(group: UnitGroup) -> Player {
        if attackFleetArray.contains(group) {
            return Player.attacker
        } else {
            return Player.defender
        }
    }
    
    func playerGroupForPlayer(player: Player) -> PlayerGroup {
        let newPlayerGroup = PlayerGroup()
        let fleetArray = fleetForPlayer(player)
        for group in fleetArray {
            for unit in group.units {
                newPlayerGroup.addUnit(unit)
            }
        }
        
        if player == Player.attacker {
            newPlayerGroup.isDesignatedAttacker = true
        } else {
            newPlayerGroup.isDesignatedAttacker = false
        }
        
        return newPlayerGroup
        
    }
    
    func resetAllUnitStats() {
        let allFleets = [attackFleetArray, defendFleetArray]
        for fleet in allFleets {
            for group in fleet {
                for unit in group.units {
                    unit.killCount = 0
                    unit.destroyedCount = 0
                    unit.survivalCount = 0
                }
            }
        }
        
    }
}