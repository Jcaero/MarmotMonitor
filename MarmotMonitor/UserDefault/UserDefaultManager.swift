//
//  UserDefaultManager.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 06/01/2024.
//

import Foundation

protocol UserDefaultManagerProtocol {
    func saveBabyName(_ name: String?)
    func saveGender(_ gender: Gender)
    func saveParentName(_ name: String?)
    func saveDateOfBirth(_ date: String?)
    func saveGraphType(_ graphType: GraphType)
    func getBabyName() -> String?
    func getGender() -> String?
    func getParentName() -> String?
    func getBirthDay() -> String?
    func getGraphType() -> GraphType?

//    func save(property: MarmotProperty)
//    func get(property: MarmotProperty)
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

    // Get Value
    func getBabyName() -> String? {
        return defaults.string(forKey: UserInfoKey.babyName.rawValue)
    }

    func getGender() -> String? {
        return defaults.string(forKey: UserInfoKey.gender.rawValue)
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

}
