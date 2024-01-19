//
//  ActivityType.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 12/01/2024.
//

import Foundation

enum ActivityType {
    case diaper(state: DiaperState)
    case bottle(quantity: Int)
    case breast(duration: BreastDuration)
    case sleep(duration: Int)
    case growth(data: GrowthData)
    case solide(composition: SolidQuantity)

    var alertMessage: String {
           switch self {
           case .diaper:
               return "Une couche a déjà été enregistrée à cette date."
           case .bottle:
               return "Un biberon a déjà été enregistrée à cette date."
           case .breast:
               return "Une session d'allaitement a déjà été enregistrée à cette date."
           case .sleep:
               return "Un temps de sommeil a déjà été enregistrée à cette date."
           case .growth:
               return "Une mesure de croissance a déjà été enregistrée à cette date."
           case .solide:
               return "Un repas a déjà été enregistrée à cette date."
           }
       }

    static var diaperAlert: String {
            return "Une couche a déjà été enregistrée à cette date."
        }
}

enum DiaperState: String, CaseIterable {
    case wet = "Urine"
    case dirty = "Souillée"
    case both = "Mixte"
}

struct BreastDuration {
    let leftDuration: Int
    let rightDuration: Int
}

struct SolidQuantity {
    let vegetable: Int
    let meat: Int
    let fruit: Int
    let dairyProduct: Int
    let cereal: Int
    let other: Int
}

struct GrowthData {
    let weight: Int
    let height: Int
    let headCircumference: Int
}
