//
//  AppIcon.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 09/02/2024.
//

import UIKit

enum NIAppIconType: CaseIterable {
    case defaultIcon, appiconGreen, appiconBlue, appiconPink, appiconRed, appiconDarkBlue

    var name: String {
        switch self {
        case .defaultIcon:
            return "AppIcon"
        case .appiconGreen:
            return "iconeVerte"
        case .appiconBlue:
            return "iconeBleue"
        case .appiconPink:
            return "iconeRose"
        case .appiconRed:
            return "iconeRouge"
        case .appiconDarkBlue:
            return "iconeBleueFonce"
        }
    }

    var alternateIconName: String {
        switch self {
        case .defaultIcon:
            return "AppIcon"
        case .appiconGreen:
            return "iconeVerte"
        case .appiconBlue:
            return "iconeBleue"
        case .appiconPink:
            return "iconeRose"
        case .appiconRed:
            return "iconeRouge"
        case .appiconDarkBlue:
            return "iconeBleueFonce"
        }
    }
}
