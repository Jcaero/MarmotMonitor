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
}

enum GraphType {
    case round
    case rod
    case ligne
}

enum ShowActivityType {
    case diaper
    case breast
    case bottle
    case solid
    case sleep
}
