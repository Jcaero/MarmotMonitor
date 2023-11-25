//
//  File.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 25/11/2023.
//

import Foundation

final class BabyNameViewModel {
    private let defaults: UserDefaults

    init(defaults: UserDefaults = UserDefaults.standard) {
        self.defaults = defaults
    }

    func saveBabyName(name: String) {
        defaults.set(name, forKey: "babyName")
    }
}
