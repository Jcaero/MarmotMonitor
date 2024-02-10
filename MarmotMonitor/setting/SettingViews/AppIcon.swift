//
//  AppIcon.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 09/02/2024.
//

import UIKit

enum AppIcon: CaseIterable {
  case `default`
  case updateGreen
  
  var name: String? {
    switch self {
    case .default:
      return nil
    case .updateGreen:
      return "IconeVerte"
    }
  }
  
  var description: String {
    switch self {
    case .default:
      return "Default"
    case .updateGreen:
      return "Icone Fond vert"
    }
  }
  
    var icon: UIImage {
    switch self {
    case .default:
      return UIImage(named:"iconeNoire")!
    case .updateGreen:
        return UIImage(named:"iconeVerte")!
    }
  }
}

extension AppIcon {
    init(from name: String) {
        switch name {
        case "iconeVerte": self = .updateGreen
        default: self = .default
        }
    }
}
