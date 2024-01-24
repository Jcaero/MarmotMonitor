//
//  GraphType.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 23/01/2024.
//

import UIKit

struct ShowActivity {
    let color: UIColor
    let timeStart: Date
    let duration: Int
}

enum GraphType {
    case round
    case rod
    case ligne
}
