//
//  HomeViewModel.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 04/12/2023.
//

import Foundation

struct Activity {
    let imageName: String
    let cellTitle: String
    let cellSubTitle: String
}

class TodayViewModel {
    private let userDefaultsManager: UserDefaultManagerProtocol!

    static let activities: [Activity] = [
           Activity(imageName: "biberon", cellTitle: "Dernière tétée/biberon", cellSubTitle: "Saisir la tétée/le biberon"),
           Activity(imageName: "couche", cellTitle: "Dernier sommeil", cellSubTitle: "Saisir le sommeil"),
           Activity(imageName: "sommeil", cellTitle: "Dernière couche", cellSubTitle: "Saisir la couche"),
           Activity(imageName: "croissance", cellTitle: "Croissance", cellSubTitle: "Ajouter une mesure")
       ]

    init(userDefaultsManager: UserDefaultManagerProtocol = UserDefaultsManager()) {
        self.userDefaultsManager = userDefaultsManager
    }

    // MARK: - Person Data
    private func requestPersonData() -> Person? {
        guard let babyName = userDefaultsManager.getBabyName() else { return nil }
        let gender = userDefaultsManager.getGender()
        let parentName = userDefaultsManager.getParentName()
        let birthDayString = userDefaultsManager.getBirthDay()

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
