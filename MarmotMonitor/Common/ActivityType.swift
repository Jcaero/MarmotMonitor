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
    case breast(duration: BreastDuration)

    var alertMessage: String {
           switch self {
           case .diaper:
               return "Une couche a déja été enregistrée à cette date."
           case .bottle:
               return "Un biberon a déja été enregistrée à cette date."
           case .breast:
               return "Une session d'allaitement a déja été enregistrée à cette date."
           }
       }
}

enum State: String {
    case wet = "Urine"
    case dirty = "Souillée"
    case both = "Mixte"
}

enum BreastSide: String {
    case left = "Gauche"
    case right = "Droite"
}

struct BreastDuration {
    let leftDuration: Int
    let rightDuration: Int
    let first: BreastSide
}
