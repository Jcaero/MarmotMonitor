//
//  HomeViewModel.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 04/12/2023.
//

import Foundation

class TodayViewModel {
    private let defaults: UserDefaults
    let imageName = ["biberon", "couche", "sommeil", "croissance"]
    let acitivityCellTitle = ["Dernière tétée/biberon", "Dernier sommeil", "Dernière couche", "Croissance"]
    let acitivityCellSubTitle = ["Saisir la tétée/le biberon", "Saisir le sommeil", "Saisir la couche", "Ajouter une mesure"]

    init(defaults: UserDefaults = UserDefaults.standard) {
        self.defaults = defaults
    }

    // MARK: - Person Data
    func requestPersonData() -> Person? {
        guard let babyName = defaults.string(forKey: UserInfoKey.babyName.rawValue) else { return nil }

        let gender = defaults.string(forKey: UserInfoKey.gender.rawValue)

        let parentName = defaults.string(forKey: UserInfoKey.parentName.rawValue)

        let birthDayString = defaults.string(forKey: UserInfoKey.birthDay.rawValue)

        return Person(name: babyName, gender: gender, parentName: parentName, birthDay: birthDayString)
    }

    // MARK: - Welcome Texte
    func welcomeTexte() -> String {

        guard let person = requestPersonData() else {return ""}

        if let parentName = person.parentName {
            return "Bonjour \(parentName.capitalizeFirstLetter()) et \(person.name.capitalizeFirstLetter())"
        } else {
            return "Bonjour \(person.name)"
        }
    }

    // MARK: - Age
    private func babyAge() -> DateComponents? {
        guard let birthDayDate = requestPersonData()?.birthDay?.toDate() else {
            return nil
        }
        return Calendar.current.dateComponents([.year, .month], from: birthDayDate, to: Date())
    }

    func babyYear() -> String {
        guard let age = babyAge() else { return "" }
        return "\(age.year ?? 0)"
    }

    func babyMonth() -> String {
        guard let age = babyAge() else { return "" }
        return "\(age.month ?? 0)"
    }
}
