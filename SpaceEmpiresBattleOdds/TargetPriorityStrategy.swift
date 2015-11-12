//
//  TargetPriorityStrategy.swift
//  SpaceEmpiresBattleOdds
//
//  Created by Tibor Grose on 10/29/15.
//  Copyright © 2015 Tibor Grose. All rights reserved.
//

import Foundation

enum TargetPriorityStrategy: Int {
    case random = 0, highThreat, easyKill
    
    static let allStrategies = [random, highThreat, easyKill]
    
    func name() -> String {
        switch self {
        case .random:
            return "Random Target"
        case .highThreat:
            return "Target Highest Threat"
        case .easyKill:
            return "Target Easiest Kill"
        }        
    }
    
    func description() -> String {
        switch self {
        case .random:
            return "Randomly choose target"
        case .highThreat:
            return "Target unit which poses the greatest threat"
        case .easyKill:
            return "Target unit which is easiest to hit"
        }
    }
    
    func priorityFunction() -> (Unit, Unit) -> Bool {
        switch self {
        case .random:
            return { (lhs: Unit, rhs: Unit) -> Bool in
                let coinToss = arc4random_uniform(1)
                if coinToss == 0 {
                    return true
                } else {
                    return false
                }
            }
        case .highThreat:
            return { (lhs: Unit, rhs: Unit) -> Bool in
                // target units with the highest threat rank first
                // if threat rank is equal, target the unit most damaged
                let lhsCombatRank = lhs.unitCombatRank()
                let rhsCombatRank = rhs.unitCombatRank()
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
        case .easyKill:
            return { (lhs: Unit, rhs: Unit) -> Bool in
                let lhsDefense = lhs.baseDefense + lhs.defenseTech
                let rhsDefense = rhs.baseDefense + rhs.defenseTech
                if lhsDefense < rhsDefense {
                    return true
                }
                
                if lhsDefense == rhsDefense {
                    if lhs.hullStrength < rhs.hullStrength {
                        return true
                    }
                }
                
                return false
            }
        }
    }
}