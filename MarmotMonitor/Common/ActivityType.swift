//
//  ActivityType.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 12/01/2024.
//

import Foundation

enum ActivityType {
    case diaper(state: State)
    case bottle(quantity: Int)
}

enum State: String {
    case wet = "Urine"
    case dirty = "Souillée"
    case both = "Mixte"
}
