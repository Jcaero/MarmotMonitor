//
//  AppIcon.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 09/02/2024.
//

import UIKit

enum NIAppIconType: CaseIterable {
    case defaultIcon, appiconGreen, appiconBlue

    var name: String? {
        switch self {
        case .defaultIcon:
            return nil
        case .appiconGreen:
            return "IconeVerte"
        case .appiconBlue:
            return "IconeBleue"
        }
    }

    init(name: String) { 
        switch name {
        case "DefaultAppIcon":
            self = .defaultIcon
        case "appiconGreen":
            self = .appiconGreen
        case "appiconBlue":
            self = .appiconBlue
        default:
            self = .defaultIcon
        }
    }

    var alternateIconName: String {
        switch self {
        case .defaultIcon:
            return "iconeNoire"
        case .appiconGreen:
            return "iconeVerte"
        case .appiconBlue:
            return "iconeBleue"
        }
    }
}
