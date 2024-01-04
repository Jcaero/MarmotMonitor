//
//  GenderViewModel.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 25/11/2023.
//
import Foundation

protocol GenderDelegate: AnyObject {
    func showGender(_ gender: Gender)
}

final class GenderViewModel {
    private let defaults: UserDefaults
    var gender: Gender = .none

    private weak var delegate: GenderDelegate?

    // MARK: - init
    // init for test
    init(defaults: UserDefaults = UserDefaults.standard, delegate: GenderDelegate?) {
        self.defaults = defaults
        self.delegate = delegate
    }

    func buttonTappedWithGender(_ gender: Gender) {
        self.gender = gender != self.gender ? gender : .none
        delegate?.showGender(self.gender)
    }

    func saveGender() {
        if gender != .none {
            defaults.set(gender.description, forKey: UserInfoKey.gender.rawValue)
        } else {
            defaults.removeObject(forKey: UserInfoKey.gender.rawValue)
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
