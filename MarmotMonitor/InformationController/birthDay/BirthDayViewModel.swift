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

    enum InputDate {
        case date(Date)
        case stringDate(String)
    }

    func save(date birthdayDate: BirthDayViewModel.InputDate) {
        var dateString: String!

        switch birthdayDate {
        case .date(let date):
            dateString = date.toStringWithDayMonthYear()
        case .stringDate(let string):
            dateString = string
        }

        let dateIsValid = check(dateString)

        if dateIsValid {
            defaults.set(dateString, forKey: UserInfoKey.birthDay.rawValue)

            delegate?.pushToNextView()
        }
    }

    private func check(_ dateString: String) -> Bool {
        guard let date = dateString.toDate() else {
            delegate?.showAlert(title: "Erreur", description: "Le format de la date de naissance n'est pas valide")
            return false
        }

        guard date <= Date() else {
            delegate?.showAlert(title: "Erreur", description: "Veuillez entrer une date de naissance antérieure à la date d'aujourd'hui.")
            return false
        }
        return true
    }
}
