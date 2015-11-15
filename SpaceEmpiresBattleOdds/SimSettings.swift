//
//  SimSettings.swift
//  SpaceEmpiresBattleOdds
//
//  Created by Tibor Grose on 11/9/15.
//  Copyright © 2015 Tibor Grose. All rights reserved.
//

import Foundation

let attackerTargetStratKey = "attakerTargetKey"
let defenderTargetStratKey = "defenderTargetKey"
let attackerScreeningStratKey = "attackerScreenKey"
let defenderScreeningStratKey = "defenderScreenKey"
let simIterationsKey = "simIterationsKey"

protocol SimSettingsDelegate {
    func targetStrategyChangedForPlayer(player: Player)
    func screeningStrategyChangedForPlayer(player: Player)
}

class SimSettings {
    static let sharedInstance = SimSettings()
    
    
    var delegate: SimSettingsDelegate?
    
    var simIterations = 1000 {
        didSet {
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setInteger(simIterations, forKey: simIterationsKey)
            print("Interations changed to \(simIterations)")
        }
    }
    
    private init() {
        // read defaults from NSUserDefaults
        let defaults = NSUserDefaults.standardUserDefaults()
        simIterations = defaults.integerForKey(simIterationsKey)
        if let attackTargetStrat = TargetPriorityStrategy(rawValue: defaults.integerForKey(attackerTargetStratKey)) {
            attackerTargetStrategy = attackTargetStrat
        }
        if let attackScreenStrat = ScreeningStrategy(rawValue: defaults.integerForKey(attackerScreeningStratKey)) {
            attackerScreeningStrategy = attackScreenStrat
        }
        if let defendTargetStrat = TargetPriorityStrategy(rawValue: defaults.integerForKey(defenderTargetStratKey)) {
            defenderTargetStrategy = defendTargetStrat
        }
        if let defendScreenStrat = ScreeningStrategy(rawValue: defaults.integerForKey(defenderScreeningStratKey)) {
            defenderScreeningStrategy = defendScreenStrat
        }
        
    }
    
    var attackerTargetStrategy = TargetPriorityStrategy.random
    var attackerScreeningStrategy = ScreeningStrategy.none
    var defenderTargetStrategy = TargetPriorityStrategy.random
    var defenderScreeningStrategy = ScreeningStrategy.none
    
    func targetStrategyForPlayer(player: Player) -> TargetPriorityStrategy {
        return player == Player.attacker ? attackerTargetStrategy : defenderTargetStrategy
    }
    
    func screeningStrategyForPlayer(player: Player) -> ScreeningStrategy {
        return player == Player.attacker ? attackerScreeningStrategy : defenderScreeningStrategy
    }
    
    func setTargetStrategyForPlayer(player: Player, strategy:TargetPriorityStrategy) {
        let defaults = NSUserDefaults.standardUserDefaults()
        switch player {
        case .attacker:
            attackerTargetStrategy = strategy
            defaults.setInteger(strategy.rawValue, forKey: attackerTargetStratKey)
        case .defender:
            defenderTargetStrategy = strategy
            defaults.setInteger(strategy.rawValue, forKey: defenderTargetStratKey)
        }
        
        delegate?.targetStrategyChangedForPlayer(player)
    }
    
    func setScreeningStrategyForPlayer(player: Player, strategy:ScreeningStrategy) {
        let defaults = NSUserDefaults.standardUserDefaults()
        switch player {
        case .attacker:
            attackerScreeningStrategy = strategy
            defaults.setInteger(strategy.rawValue, forKey: attackerScreeningStratKey)
        case .defender:
            defenderScreeningStrategy = strategy
            defaults.setInteger(strategy.rawValue, forKey: defenderScreeningStratKey)
        }
        
        delegate?.screeningStrategyChangedForPlayer(player)
    }
}