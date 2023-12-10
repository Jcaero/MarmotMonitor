//
//  BackgroundViewModel.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 10/12/2023.
//

import Foundation

final class BackgroundViewModel {
    private let defaults: UserDefaults

    init(defaults: UserDefaults = UserDefaults.standard) {
        self.defaults = defaults
    }

    // MARK: - Gender
    func getGender() -> String? {
        return defaults.string(forKey: UserInfoKey.gender.rawValue)
    }
}
