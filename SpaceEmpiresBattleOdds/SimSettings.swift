//
//  SimSettings.swift
//  SpaceEmpiresBattleOdds
//
//  Created by Tibor Grose on 11/9/15.
//  Copyright © 2015 Tibor Grose. All rights reserved.
//

import Foundation

protocol SimSettingsDelegate {
    func targetStrategyChangedForPlayer(player: Player)
    func screeningStrategyChangedForPlayer(player: Player)
}

class SimSettings {
    static let sharedInstance = SimSettings()
    private init() {}
    
    var delegate: SimSettingsDelegate?
    
    var simIterations = 1000 {
        didSet {
            print("Interations changed to \(simIterations)")
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
        switch player {
        case .attacker:
            attackerTargetStrategy = strategy
        case .defender:
            defenderTargetStrategy = strategy
        }
        
        delegate?.targetStrategyChangedForPlayer(player)
    }
    
    func setScreeningStrategyForPlayer(player: Player, strategy:ScreeningStrategy) {
        switch player {
        case .attacker:
            attackerScreeningStrategy = strategy
        case .defender:
            defenderScreeningStrategy = strategy
        }
        
        delegate?.screeningStrategyChangedForPlayer(player)
    }
}