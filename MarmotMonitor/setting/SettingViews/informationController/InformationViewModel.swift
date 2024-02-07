//
//  InformationViewModel.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 05/02/2024.
//

protocol InformationViewModelDelegate: AnyObject {
    func showAlert(title: String, description: String)
}

import Foundation
class InformationViewModel {
    private weak var delegate: InformationViewModelDelegate?
    private let userDefaultsManager: UserDefaultManagerProtocol!

    var babyName: String = ""
    var parentName: String = ""
    var birthDay: String = ""
    var gender: String = ""

    init(userDefaultsManager: UserDefaultManagerProtocol = UserDefaultsManager(), delegate: InformationViewModelDelegate?) {
        self.userDefaultsManager = userDefaultsManager
        self.delegate = delegate
    }

    func getUserInformation() {
        babyName = userDefaultsManager.getBabyName() ?? "Entrer le nom"
        birthDay = userDefaultsManager.getBirthDay() ?? "JJ/MM/YYYY"
        parentName = userDefaultsManager.getParentName() ?? "Entrer le nom du parent"
        gender = userDefaultsManager.getGender() ?? ""
    }

    func saveUserInformation(babyName: String?, parentName: String?, birthDay: String?, gender: String) {
        if babyName != "" {
            if babyName!.isLengthValidAndOnlyLetters {
                userDefaultsManager.saveBabyName(babyName)
            } else {
                delegate?.showAlert(title: "Erreur", description: "Le nom de l'enfant doit contenir au moins 3 lettres")
            }
        }

        if birthDay != "" {
            let birthDayDate = transformInDate(birthDay)
            if birthDayDate != nil {
                userDefaultsManager.saveDateOfBirth(birthDayDate)
            }
        }

        if parentName != "" {
            userDefaultsManager.saveParentName(parentName)
        }

        let gender = transformInGender(gender)
        userDefaultsManager.saveGender(gender)
    }
}

extension InformationViewModel {
    private func transformInDate(_ dateString: String?) -> String? {
        guard let date = dateString?.toDate() else {
            delegate?.showAlert(title: "Erreur", description: "Le format de la date de naissance n'est pas valide")
            return nil
        }

        guard date <= Date() else {
            delegate?.showAlert(title: "Erreur", description: "Veuillez entrer une date de naissance antérieure à la date d'aujourd'hui.")
            return nil
        }
        return date.toStringWithDayMonthYear()
    }

    private func transformInGender(_ gender: String) -> Gender {
        switch gender {
        case "Fille":
            return .girl
        case "Garçon":
            return .boy
        default:
            return .none
        }
    }
}
