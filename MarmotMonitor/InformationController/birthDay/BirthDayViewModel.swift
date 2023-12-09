//
//  BirthDayViewModel.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 26/11/2023.
//
protocol BirthDayDelegate: AnyObject {
    func showAlert(title: String, description: String)
    func pushToNextView()
}

import Foundation

final class BirthDayViewModel {
    private let defaults: UserDefaults
    private weak var delegate: BirthDayDelegate?

    init(defaults: UserDefaults = UserDefaults.standard, delegate: BirthDayDelegate?) {
        self.defaults = defaults
        self.delegate = delegate
    }
    func saveBirthDate(stringDate: String) {
        guard let date = stringDate.toDate() else {
            delegate?.showAlert(title: "Erreur", description: "Le format de la date de naissance n'est pas valide")
            return
        }

        guard date <= Date() else {
            delegate?.showAlert(title: "Erreur", description: "Veuillez entrer une date de naissance antérieure à la date d'aujourd'hui.")
            return
        }

        saveToDefaultsBirthDayString(date: stringDate)
        delegate?.pushToNextView()
    }

    func saveBirthDate(date: Date) {
        let formatedDate = date.toStringWithDayMonthYear()
        saveBirthDate(stringDate: formatedDate)
    }

    private func saveToDefaultsBirthDayString( date: String) {
        defaults.set(date, forKey: UserInfoKey.birthDay.rawValue)
    }
}
