//
//  ScreeningStrategy.swift
//  SpaceEmpiresBattleOdds
//
//  Created by Tibor Grose on 10/29/15.
//  Copyright © 2015 Tibor Grose. All rights reserved.
//

import Foundation

enum ScreeningStrategy: Int {
    case none = 0, protectDamaged, protectCriticallyDamaged
    
    static let allStrategies = [none, protectDamaged, protectCriticallyDamaged]
    
    func name() -> String {
        switch self {
        case .none:
            return "No Screening"
        case .protectDamaged:
            return "Screen Damaged"
        case .protectCriticallyDamaged:
            return "Screen Critically Damaged"
        }
    }
    
    func description() -> String {
        switch self {
        case .none:
            return "No Screening"
        case .protectDamaged:
            return "Screen any damaged ship"
        case .protectCriticallyDamaged:
            return "Screen any damaged ship with only one hull left"
        }
    }

}