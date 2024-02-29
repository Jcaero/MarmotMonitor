//
//  GraphType.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 23/01/2024.
//

import UIKit

struct GraphActivity {
    let type: ShowActivityType
    let color: UIColor
    let timeStart: Date
    let duration: Int
    var quantity: Int?
    var timeOfOrigine: Date?
}

enum GraphType {
    case round
    case rod
    case ligne

    var description: String {
        switch self {
        case .round:
            return "pixel"
        case .rod:
            return "bar"
        case .ligne:
            return "ligne"
        }
    }

    var imageNameSynthese: String {
        switch self {
        case .round:
            return "graphRound"
        case .rod:
            return "graphRod"
        case .ligne:
            return "graphLigne"
        }
    }
}

enum ShowActivityType {
    case diaper
    case breast
    case bottle
    case solid
    case sleep
}
