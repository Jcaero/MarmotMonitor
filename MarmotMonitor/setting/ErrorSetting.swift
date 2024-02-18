//
//  ErrorSetting.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 17/02/2024.
//

import Foundation
enum ErrorSetting: Error {
    case invalidName
    case invalidDateFormat
    case invalidDateBirth
    case invalidParentName
    case invalidGender
    case invalideNameLength

    var description: String {
        switch self {
        case .invalidName:
            return "Le nom de l'enfant doit contenir au moins 3 lettres"
        case .invalidDateFormat:
            return "Le format de la date de naissance n'est pas valide"
        case .invalidParentName:
            return "Le nom du parent est invalide"
        case .invalidGender:
            return "Le genre est invalide"
        case .invalideNameLength:
            return "Le nom de l'enfant doit contenir au moins 3 lettres"
        case .invalidDateBirth:
            return "Veuillez entrer une date de naissance antérieure à la date d'aujourd'hui."
        }
    }
}
