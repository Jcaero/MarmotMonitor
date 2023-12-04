//
//  HomeViewModel.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 04/12/2023.
//

import Foundation

class TodayViewModel {
    private let defaults: UserDefaults

    init(defaults: UserDefaults = UserDefaults.standard) {
        self.defaults = defaults
    }

    func requestPersonData() -> Person? {
        guard let babyName = defaults.string(forKey: UserInfoKey.babyName.rawValue) else { return nil }

        let gender = defaults.string(forKey: UserInfoKey.gender.rawValue)

        let parentName = defaults.string(forKey: UserInfoKey.parentName.rawValue)

        let birthDayString = defaults.string(forKey: UserInfoKey.birthDay.rawValue)

        return Person(name: babyName, gender: gender, parentName: parentName, birthDay: birthDayString)
    }
}
