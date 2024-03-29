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

final class TodayViewModel {
    private let userDefaultsManager: UserDefaultManagerProtocol!
    private let marmotMonitorSaveManager: MarmotMonitorSaveManagerProtocol!

    var activities: [ActivityData] = [
        ActivityData(imageName: ActivityIconName.meal.rawValue , cellTitle: "Dernière tétée/biberon", cellSubTitle: "Saisir la tétée/le biberon"),
           ActivityData(imageName: ActivityIconName.sleep.rawValue, cellTitle: "Dernier sommeil", cellSubTitle: "Saisir le sommeil"),
           ActivityData(imageName: ActivityIconName.diaper.rawValue, cellTitle: "Dernière couche", cellSubTitle: "Saisir la couche"),
           ActivityData(imageName: ActivityIconName.growth.rawValue, cellTitle: "Croissance", cellSubTitle: "Ajouter une mesure")
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
            return "Bonjour \(parentName.capitalizeFirstLetter()) et \(person.name!.capitalizeFirstLetter())"
        } else {
            return "Bonjour \(String(describing: person.name!.capitalizeFirstLetter()))"
        }
    }

    // MARK: - Age
    private func babyAge() -> DateComponents? {
        guard let birthDayDate = requestPersonData()?.birthDay?.toDate() else {
            return nil
        }
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "Europe/Paris")!
        let now = Date() // La date et l'heure actuelles en UTC
        let startOfDayInFrance = calendar.startOfDay(for: now)

        return Calendar.current.dateComponents([.year, .month, .day], from: birthDayDate, to: startOfDayInFrance)
    }

    func babyFirstElement() -> String {
        guard let age = babyAge() else { return "" }
        if let year = age.year, year > 0 {
            return "\(year)\nans"
        } else {
            guard let month = age.month, month > 0 else { return "" }
            return "\(month)\nmois"
        }
    }

    func babySecondElement() -> String {
        guard let age = babyAge() else { return "" }
        if let year = age.year, year > 0 {
            guard let month = age.month else { return "" }
            return "\(month)\nmois"
        } else {
            guard let day = age.day else { return "" }
            return "\(day)\njours"
        }
    }

    func convertAgeFormatAccessibility(originalText: String) -> String {
        switch true {
        case originalText.hasSuffix("ans"):
            return originalText.replacingOccurrences(of: "ans", with: "A").replacingOccurrences(of: "\n", with: "")
        case originalText.hasSuffix("mois"):
            return originalText.replacingOccurrences(of: "mois", with: "M").replacingOccurrences(of: "\n", with: "")
        case originalText.hasSuffix("jours"):
            return originalText.replacingOccurrences(of: "jours", with: "J").replacingOccurrences(of: "\n", with: "")
        default:
            return originalText
        }
    }

    func convertAgeFormatNormal(originalText: String) -> String {
        switch true {
        case originalText.hasSuffix("A"):
            return originalText.replacingOccurrences(of: "A", with: "\nans")
        case originalText.hasSuffix("M"):
            return originalText.replacingOccurrences(of: "M", with: "\nmois")
        case originalText.hasSuffix("J"):
            return originalText.replacingOccurrences(of: "J", with: "\njours")
        default:
            return originalText
        }
    }

    // MARK: - Update Last Value
    func fetchLastActivities() {
        fetchDiaper()
        fetchFood()
        fetchSleep()
        fetchGrowth()
    }

    private func fetchDiaper() {
        guard let result = marmotMonitorSaveManager.fetchFirstActivity(ofType: Diaper.self), let status = result.activity.state else { return }
        let date = result.date.toStringWithTimeAndDayMonthYear()
        let cellTitle = date + " " + status
        activities[2]=ActivityData(imageName: ActivityIconName.diaper.rawValue, cellTitle: "Dernière couche", cellSubTitle: cellTitle)
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

        activities[0] = ActivityData(imageName: ActivityIconName.meal.rawValue, cellTitle: "Dernière tétée/biberon", cellSubTitle: cellTitle)
    }

    private func fetchSleep() {
        guard let result = marmotMonitorSaveManager.fetchFirstActivity(ofType: Sleep.self) else { return }
        let date = result.date.toStringWithTimeAndDayMonthYear()
        let duration = result.activity.duration
        let stringDuration = Int(duration).toTimeString()
        let cellTitle = date + " " + stringDuration
        activities[1] = ActivityData(imageName: ActivityIconName.sleep.rawValue, cellTitle: "Dernier sommeil", cellSubTitle: cellTitle)
    }

    private func fetchGrowth() {
        guard let result = marmotMonitorSaveManager.fetchFirstActivity(ofType: Growth.self) else { return }
        let date = result.date.toStringWithTimeAndDayMonthYear()

        var cellTitle = date + " "
        if result.activity.height != 0 {
            cellTitle += "Taille: " + String(result.activity.height) + " cm "
        }
        if result.activity.weight != 0 {
            cellTitle += "Poids: " + String(result.activity.weight) + " Kg"
        }

        activities[3] = ActivityData(imageName: ActivityIconName.growth.rawValue, cellTitle: "Croissance", cellSubTitle: cellTitle)
    }
}
