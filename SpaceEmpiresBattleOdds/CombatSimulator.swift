//
//  CombatSimulator.swift
//  SpaceEmpiresBattleOdds
//
//  Created by Tibor Grose on 10/27/15.
//  Copyright © 2015 Tibor Grose. All rights reserved.
//

import Foundation

// move these enums into their own files




class CombatSimulator {
    private var attackGroup : PlayerGroup
    private var defendGroup : PlayerGroup
    private var currentRound : Int
    
    init(attacker: PlayerGroup, defender: PlayerGroup /* attack and defend strategies needed */) {
        self.attackGroup = attacker
        self.defendGroup = defender
        self.currentRound = 1
    }
    
    func printGroupStatus() {
        print("Attacker: \(attackGroup.descriptionStatus())" + "\n" + "Defender: \(defendGroup.descriptionStatus())")
    }
    
    func isUnitCombatEligible(unit: Unit) -> Bool {
        // If a unit is both not destroyed and not screened, it's eligible for combat
        if (!unit.isDestroyed() && !unit.isScreened) {
            return true
        }
        
        return false
    }
    
    func screenUnits() {
        // Just sets all units to unscreened for now
        let allGroups = [attackGroup, defendGroup]
        for group in allGroups {
            for unit in group.groupUnits() {
                unit.isScreened = false
            }
        }
    }
    
    func determineGroupSizeBonus() {
        let attackSize = attackGroup.activeGroupSize()
        let defendSize = defendGroup.activeGroupSize()
        
        //initialize group size bonus for both groups
        attackGroup.isGroupSizeBonusEligible = false
        defendGroup.isGroupSizeBonusEligible = false
        
        // is attacker at least twice the size of the defender
        if attackSize >= defendSize * 2 {
            attackGroup.isGroupSizeBonusEligible = true
            defendGroup.isGroupSizeBonusEligible = false
            
            //print("Attacker receives Size Bonus")
            
            return
        }
        
        // is the defender at least twice the size of the attacker
        if defendSize >= attackSize * 2 {
            attackGroup.isGroupSizeBonusEligible = false
            defendGroup.isGroupSizeBonusEligible = true
            
            //print("Defender receives Size Bonus")
            
            return
        }
        
        //print("Neither Side receives Size Bonus")
    }
    
    func allCombatEligibleUnits() -> Set<Unit> {
        var returnSet = Set<Unit>()
        let allUnits = attackGroup.groupUnits().union(defendGroup.groupUnits())
        for unit in allUnits {
            if isUnitCombatEligible(unit) == true {
                returnSet.insert(unit)
            }
        }
        
        return returnSet
    }
    
    func combatEligibleUnits(units: Set<Unit>) -> Set<Unit> {
        var returnSet = Set<Unit>()
        for unit in units {
            if isUnitCombatEligible(unit) == true {
                returnSet.insert(unit)
            }
        }
        
        return returnSet
    }
    
    func unitsOfInitGroup(groupIndex: Int, units: Set<Unit>) -> Set<Unit> {
        var returnSet = Set<Unit>()
        for unit in units {
            if unit.initiativeGroup == groupIndex {
                returnSet.insert(unit)
            }
        }
        
        return returnSet
    }
    
    func initiativeOrderArrayForUnits(combatUnits: Set<Unit>) -> [Unit] {
        // fill initiativeOrderArray with units in correct combat order
        // combatUnits should have all environmental modifiers applied to them before determining order
        
        // reset init order array
        var initiativeOrderArray = [Unit]()
        
        for initiativeGroupIndex in 0...4 {
            // get all units belonging to the same init group
            let initGroupUnits = unitsOfInitGroup(initiativeGroupIndex, units: combatUnits)
            
            // sort the units and append them to the init order array
            initiativeOrderArray += initGroupUnits.sort(unitInitiativeSort)
        }
        
        return initiativeOrderArray
    }
    
    func targetPriorityArrayForUnits(units: Set<Unit>, targetStrategy: (Unit, Unit) -> Bool) -> [Unit] {
        return units.sort(targetStrategy)
    }
    
    // decending sort, highest tatic tech first, tie goes to defender
    func unitInitiativeSort(lhs: Unit, rhs: Unit) -> Bool {
        if lhs.taticTech > rhs.taticTech {
            return true
        }
        
        if lhs.taticTech == rhs.taticTech {
            if lhs.isDesignatedAttacker == false {
                return true
            }
        }
        
        return false
    }
    
    func unitCombatRank(unit: Unit) -> Int {
        return (unit.baseAttack + unit.attackTech + unit.baseDefense + unit.defenseTech + unit.taticTech) * unit.hullStrength
    }
    
    func highCombatRankTargetFirstSort(lhs: Unit, rhs: Unit) -> Bool {
        // target units with the highest threat rank first
        // if threat rank is equal, target the unit most damaged
        let lhsCombatRank = unitCombatRank(lhs)
        let rhsCombatRank = unitCombatRank(rhs)
        if lhsCombatRank > rhsCombatRank {
            return true
        }
        
        if lhsCombatRank == rhsCombatRank {
            if lhs.hullStrength < rhs.hullStrength {
                return true
            }
        }
        
        return false
    }
    
    func lowestHullStrengthFirstSort(lhs: Unit, rhs: Unit) -> Bool {
        return lhs.hullStrength < rhs.hullStrength
    }
    
    func highestEconomicValueFirstSort(lhs: Unit, rhs: Unit) -> Bool {
        return lhs.econValue > lhs.econValue
    }
    
    func highestChanceOfKillingSort(lhs: Unit, rhs: Unit) -> Bool {
        let lhsDefense = lhs.baseDefense + lhs.defenseTech
        let rhsDefense = rhs.baseDefense + rhs.defenseTech
        if lhsDefense < rhsDefense {
            return true
        }
        
        if lhsDefense == rhsDefense {
            return lowestHullStrengthFirstSort(lhs, rhs: rhs)
        }
        
        return false
    }
    
    func nextEligilbeTargetFromPriorityArray(targets: [Unit]) -> Unit? {
        
        var nextTarget: Unit?
        
        for targetCandidate in targets {
            if targetCandidate.isDestroyed() {
                continue
            } else {
                nextTarget = targetCandidate
                break
            }
        }
        
        return nextTarget
    }
    
    func targetForUnit(unit: Unit, attackersTargets: [Unit], defendersTargets: [Unit]) -> Unit? {
        
        var target: Unit?
        
        if unit.isDesignatedAttacker {
            target = nextEligilbeTargetFromPriorityArray(attackersTargets)
        } else {
            target = nextEligilbeTargetFromPriorityArray(defendersTargets)
        }
        
        return target
    }
    
    func resolveAttackByUnit(attacker: Unit, defender: Unit) -> Bool {
        let dieRoll = Int(arc4random_uniform(10) + 1)
        var resultNeeded = attacker.baseAttack + attacker.attackTech - defender.baseDefense - defender.defenseTech
        if attacker.hasGroupSizeAttackBonus {
            resultNeeded++
        }
        // result needed for success is never less than 1
        if resultNeeded < 1 {
            resultNeeded = 1
        }
        
        //print("Roll:\(dieRoll) needed:\(resultNeeded)")
        return dieRoll <= resultNeeded
    }
    
    func runCombatRound() {
        // determine screening
        
        // determine fleet size bonus
        determineGroupSizeBonus()
        
        // apply environmental effects (asteriods, nebula, etc)
        
        // determine initiative order
        let attackGroupCombatants = combatEligibleUnits(attackGroup.groupUnits())
        let defendGroupCombatants = combatEligibleUnits(defendGroup.groupUnits())
        
        let initiativeOrderArray = initiativeOrderArrayForUnits(attackGroupCombatants.union(defendGroupCombatants))
        
        // determine target priorities for both sides
        let attackerTargetStrat = SimSettings.sharedInstance.targetStrategyForPlayer(Player.attacker)
        let defenderTargetStrat = SimSettings.sharedInstance.targetStrategyForPlayer(Player.defender)
        let attackGroupTargetPriorityArray = targetPriorityArrayForUnits(defendGroupCombatants, targetStrategy: attackerTargetStrat.priorityFunction())
        let defendGroupTargetPriorityArray = targetPriorityArrayForUnits(attackGroupCombatants, targetStrategy: defenderTargetStrat.priorityFunction())
        
        // resolve combat
        for activeUnit in initiativeOrderArray {
            // initialize log string
            var log = "Round \(currentRound):"
            // if unit is dead, skip to next unit
            if activeUnit.isDestroyed() {
                continue
            }
            
            let possibleTarget = targetForUnit(activeUnit, attackersTargets: attackGroupTargetPriorityArray, defendersTargets: defendGroupTargetPriorityArray)
            
            // if target is nil, one side has been wiped out
            if let target = possibleTarget {
                
                // add participants to log
                log += " \(activeUnit.descriptionShort()) -> \(target.descriptionShort())"
                
                // did attack succeed
                if resolveAttackByUnit(activeUnit, defender: target) {
                    
                    // attack was successful, damage target
                    target.hullStrength--
                    // update unit stats
                    if target.isDestroyed() {
                        activeUnit.killCount++
                        target.destroyedCount++
                    }
                    
                    // log success
                    log += " *Hit*"
                    if target.isDestroyed() {
                        log += " DESTROYED"
                    }
                    
                } else {
                    
                    // log failure
                    log += " Miss"
                }
                
            }
            
            //print(log)
            
        } // all units in the initiativeOrderArray have had a chance to fire or been destroyed
        
    }
    
    func isBattleFinished() -> Bool {
        // if there are no eligible combat units in either the attacker or defender, the battle is over
        return combatEligibleUnits(attackGroup.groupUnits()).count == 0 ||
               combatEligibleUnits(defendGroup.groupUnits()).count == 0
    }
    
    func didAttackGroupWin() -> Bool {
        return combatEligibleUnits(defendGroup.groupUnits()).count == 0
    }
    
    func runBattle(var iterations: Int) {
        while iterations > 0 {
            // reset round counter
            currentRound = 1
            
            while isBattleFinished() == false {
                runCombatRound()
                currentRound++
            }
            
            battleDidEnd()
            
            iterations--
        }
        
    }
    
    func battleDidEnd() {
        // a battle finished, do any cleanup and stats here
        
        //battle is over, tally the win
        if didAttackGroupWin() == true {
            attackGroup.winCount++
            //print("Attacker Won")
        } else {
            defendGroup.winCount++
            //print("Defender Won")
        }
        
        // check to see which units survived and increase their survival counters
        let allGroups = [attackGroup, defendGroup]
        for group in allGroups {
            for unit in group.groupUnits() {
                if unit.isDestroyed() == false {
                    unit.survivalCount++
                }
            }
        }
        
        //reset hull strength of all units
        repairAllUnits()
    }
    
    func repairAllUnits() {
        attackGroup.repairUnits()
        defendGroup.repairUnits()
    }
    
}