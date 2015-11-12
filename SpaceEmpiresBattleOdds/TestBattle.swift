//
//  TestBattle.swift
//  SpaceEmpiresBattleOdds
//
//  Created by Tibor Grose on 10/29/15.
//  Copyright © 2015 Tibor Grose. All rights reserved.
//

import Foundation

class TestBattle {
    var attackGroup = PlayerGroup()
    var defendGroup = PlayerGroup()
    var sim: CombatSimulator

    init() {
        attackGroup.isDesignatedAttacker = true
        sim = CombatSimulator(attacker: attackGroup, defender: defendGroup)
        print("Combat Sim Initialized")
    }
    
    func setUp() {
        //attackGroup.addUnit(Unit(unitClass: UnitClass.Scout))
        //attackGroup.addUnit(Unit(unitClass: UnitClass.Scout))
        //attackGroup.addUnit(Unit(unitClass: UnitClass.Scout))
        //attackGroup.addUnit(Unit(unitClass: UnitClass.Scout))
        //attackGroup.addUnit(Unit(unitClass: UnitClass.Scout))
        //attackGroup.addUnit(Unit(unitClass: UnitClass.Scout))
        //attackGroup.addUnit(Unit(unitClass: UnitClass.Cruiser))
        //defendGroup.addUnit(Unit(unitClass: UnitClass.Scout))
        //defendGroup.addUnit(Unit(unitClass: UnitClass.Scout))
        //defendGroup.addUnit(Unit(unitClass: UnitClass.Scout))
        //defendGroup.addUnit(Unit(unitClass: UnitClass.Scout))
        //defendGroup.addUnit(Unit(unitClass: UnitClass.Scout))
        //defendGroup.addUnit(Unit(unitClass: UnitClass.Battleship))
        
       /*
        let attkUnitScout1 = Unit(unitClass: UnitClass.Scout)
        let attkUnitCrusier1 = Unit(unitClass: UnitClass.Cruiser)
        
        let defUnitScout1 = Unit(unitClass: UnitClass.Scout)
        let defUnitBattleC = Unit(unitClass: UnitClass.BattleCruiser)
        defUnitBattleC.moveTech = 2
        
        PlayerFleetStore.sharedInstance.addGroupToPlayer(Player.attacker, newUnit: attkUnitScout1, groupSize:3)
        PlayerFleetStore.sharedInstance.addGroupToPlayer(Player.attacker, newUnit: attkUnitCrusier1, groupSize:5)
        
        PlayerFleetStore.sharedInstance.addGroupToPlayer(Player.defender, newUnit: defUnitBattleC, groupSize: 5)
        PlayerFleetStore.sharedInstance.addGroupToPlayer(Player.defender, newUnit: defUnitScout1, groupSize: 4)
        */
        //print("Units present:")
        //sim.printGroupStatus()
    }
    
    func runSim() {
        let simLoops = 10000
        sim.runBattle(simLoops)
        sim.printGroupStatus()
        let attackWinPercent = Float(attackGroup.winCount) / Float(simLoops)
        let defendWinPercent = Float(defendGroup.winCount) / Float(simLoops)
        print("Attacker Success Rate:\(attackWinPercent)\nDefender Success Rate:\(defendWinPercent)")
    }
    
}