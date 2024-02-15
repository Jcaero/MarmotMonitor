//
//  UserDefaultManager.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 06/01/2024.
//
import UIKit

protocol UserDefaultManagerProtocol {
    func saveBabyName(_ name: String?)
    func saveGender(_ gender: Gender)
    func saveParentName(_ name: String?)
    func saveDateOfBirth(_ date: String?)
    func saveGraphType(_ graphType: GraphType)
    func saveAppIconName(_ name: String)
    func saveApparenceSetting(_ type: UIUserInterfaceStyle)
    func getBabyName() -> String?
    func getGender() -> Gender
    func getParentName() -> String?
    func getBirthDay() -> String?
    func getGraphType() -> GraphType?
    func getAppIconName() -> String?
    func getApparenceSetting() -> UIUserInterfaceStyle
}

final class UserDefaultsManager: UserDefaultManagerProtocol {

    private let defaults: UserDefaults

    init(defaults: UserDefaults = UserDefaults.standard) {
        self.defaults = defaults
    }

    // Set Value
    func saveBabyName(_ name: String?) {
        guard let nameToSave = name, nameToSave != "" else {
            defaults.removeObject(forKey: UserInfoKey.babyName.rawValue)
            return
        }

        let lowercasedName = nameToSave.lowercased()
        let babyName = lowercasedName.prefix(1).uppercased() + lowercasedName.dropFirst()
        defaults.set(babyName, forKey: UserInfoKey.babyName.rawValue)
    }

    func saveGender(_ gender: Gender) {
        if gender != .none {
            defaults.set(gender.description, forKey: UserInfoKey.gender.rawValue)
        } else {
            defaults.removeObject(forKey: UserInfoKey.gender.rawValue)
        }
    }

    func saveParentName(_ name: String?) {
        guard let nameToSave = name, nameToSave != "" else {
            defaults.removeObject(forKey: UserInfoKey.parentName.rawValue)
            return
        }

        let lowercasedName = nameToSave.lowercased()
        let parentName = lowercasedName.prefix(1).uppercased() + lowercasedName.dropFirst()
        defaults.set(parentName, forKey: UserInfoKey.parentName.rawValue)
    }

    func saveDateOfBirth(_ date: String?) {
        guard let dateToSave = date, dateToSave != "" else {
            defaults.removeObject(forKey: UserInfoKey.birthDay.rawValue)
            return
        }
        defaults.set(dateToSave, forKey: UserInfoKey.birthDay.rawValue)
    }

    func saveGraphType(_ graphType: GraphType) {
        defaults.set(graphType.description, forKey: UserInfoKey.graphType.rawValue)
    }

    func saveAppIconName(_ name: String) {
        defaults.set(name, forKey: UserInfoKey.appIcon.rawValue)
    }

    func saveApparenceSetting(_ type: UIUserInterfaceStyle) {
            defaults.set(type.rawValue, forKey: UserInfoKey.apparence.rawValue)
        }

    // Get Value
    func getBabyName() -> String? {
        return defaults.string(forKey: UserInfoKey.babyName.rawValue)
    }

    func getGender() -> Gender {
        switch defaults.string(forKey: UserInfoKey.gender.rawValue) {
        case "Garçon":
            return .boy
        case "Fille":
            return .girl
        default:
            return .none
        }
    }

    func getParentName() -> String? {
        return defaults.string(forKey: UserInfoKey.parentName.rawValue)
    }

    func getBirthDay() -> String? {
        return defaults.string(forKey: UserInfoKey.birthDay.rawValue)
    }

    func getGraphType() -> GraphType? {
        let graph =  defaults.string(forKey: UserInfoKey.graphType.rawValue)
        switch graph {
        case GraphType.round.description:
            return .round
        case GraphType.ligne.description:
            return .ligne
        case GraphType.rod.description:
            return .rod
        default:
            return nil
        }
    }

    func getAppIconName() -> String? {
        return defaults.string(forKey: UserInfoKey.appIcon.rawValue)
    }

    func getApparenceSetting() -> UIUserInterfaceStyle {
        return UIUserInterfaceStyle(rawValue: defaults.integer(forKey: UserInfoKey.apparence.rawValue)) ?? .unspecified
    }

}
