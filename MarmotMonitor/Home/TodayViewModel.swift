//
//  HomeViewModel.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 04/12/2023.
//

import Foundation

struct ActivityData {
    let imageName: String
    let cellTitle: String
    let cellSubTitle: String
}

class TodayViewModel {
    private let userDefaultsManager: UserDefaultManagerProtocol!
    private let marmotMonitorSaveManager: MarmotMonitorSaveManagerProtocol!

    var activities: [ActivityData] = [
           ActivityData(imageName: "biberon", cellTitle: "Dernière tétée/biberon", cellSubTitle: "Saisir la tétée/le biberon"),
           ActivityData(imageName: "sommeil", cellTitle: "Dernier sommeil", cellSubTitle: "Saisir le sommeil"),
           ActivityData(imageName: "couche", cellTitle: "Dernière couche", cellSubTitle: "Saisir la couche"),
           ActivityData(imageName: "croissance", cellTitle: "Croissance", cellSubTitle: "Ajouter une mesure")
       ]

    init(userDefaultsManager: UserDefaultManagerProtocol = UserDefaultsManager(), marmotMonitorSaveManager: MarmotMonitorSaveManagerProtocol = MarmotMonitorSaveManager()) {
        self.userDefaultsManager = userDefaultsManager
        self.marmotMonitorSaveManager = marmotMonitorSaveManager
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

    // MARK: - Update Last Value
    func fetchLastActivities() {
        fetchDiaper()
        fetchFood()
    }

    private func fetchDiaper() {
        guard let result = marmotMonitorSaveManager.fetchFirstActivity(ofType: Diaper.self), let status = result.activity.state else { return }
        let date = result.date.toStringWithTimeAndDayMonthYear()
        let cellTitle = date + " " + status
        activities[2]=ActivityData(imageName: "couche", cellTitle: "Dernière couche", cellSubTitle: cellTitle)
    }

    private func fetchFood() {
        var cellTitle: String = ""
        var dateActivity: [Date] = []

        let bottleResult = marmotMonitorSaveManager.fetchFirstActivity(ofType: Bottle.self)
        let breastResult = marmotMonitorSaveManager.fetchFirstActivity(ofType: Breast.self)
        let solidResult = marmotMonitorSaveManager.fetchFirstActivity(ofType: Solid.self)

        if let bottleDate = bottleResult?.date {
            dateActivity.append(bottleDate)
        }
        if let breastDate = breastResult?.date {
            dateActivity.append(breastDate)
        }
        if let solidDate = solidResult?.date {
            dateActivity.append(solidDate)
        }

        guard !dateActivity.isEmpty else { return }

        if let mostRecentActivity = dateActivity.sorted(by: { $0 > $1 }).first {
            switch mostRecentActivity {
            case bottleResult?.date:
                let quantity = String(bottleResult!.activity.intQuantity)
                let date = bottleResult!.date.toStringWithTimeAndDayMonthYear()
                cellTitle = date + " biberon de " + quantity + " ml"

            case breastResult?.date:
                let date = breastResult!.date.toStringWithTimeAndDayMonthYear()
                let duration = breastResult!.activity.totalDuration
                let stringDuration = duration.toTimeString()
                cellTitle = date + " tétée de " + stringDuration

            case solidResult?.date:
                let date = solidResult!.date.toStringWithTimeAndDayMonthYear()
                let quantity = String(solidResult!.activity.total)
                cellTitle = date + " aliments: " + quantity + " g"

            default:
                break
            }
        }

        activities[0] = ActivityData(imageName: "biberon", cellTitle: "Dernière tétée/biberon", cellSubTitle: cellTitle)
    }
}
