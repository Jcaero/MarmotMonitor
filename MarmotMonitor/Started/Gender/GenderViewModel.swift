//
//  GenderViewModel.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 25/11/2023.
//
import Foundation

final class GenderViewModel {
    private let defaults: UserDefaults
    var gender: Gender = .none

    // MARK: - init
    // init for test
    init(defaults: UserDefaults = UserDefaults.standard) {
        self.defaults = defaults
    }

    func setBoyGender() {
        gender = .boy
    }

    func setGirlGender() {
        gender = .girl
    }

    func clearGender() {
        gender = .none
    }

    func saveGender() {
        if gender != .none {
            defaults.set(gender.description, forKey: UserInfoKey.gender.rawValue)
        }
    }
}

enum Gender {
    case boy, girl, none

    var description: String {
        switch self {
        case .boy:
            return "Garçon"
        case .girl:
            return "Fille"
        case .none:
            return ""
        }
    }
}
