//
//  Growth.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 27/12/2023.
//

import Foundation

enum Growth {
    case height
    case weight
    case head

    var unit: String {
        switch self {
        case .height, .head: return "cm"
        case .weight: return "g"
        }
    }

    var title: String {
        switch self {
        case .height: return "Taille"
        case .weight: return "Poids"
        case .head: return "Tête"
        }
    }
}
