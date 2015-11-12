//
//  SimStats.swift
//  SpaceEmpiresBattleOdds
//
//  Created by Tibor Grose on 11/10/15.
//  Copyright © 2015 Tibor Grose. All rights reserved.
//

import Foundation

class SimStats {
    static let sharedInstance = SimStats()
    private init() {}
    
    var attackerWins = 0
    var defenderWins = 0
    
    func resetAll() {
        attackerWins = 0
        defenderWins = 0
    }
}