//
//  ParentNameViewController.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 25/11/2023.
//

import Foundation

final class ParentNameViewModel {
    private let defaults: UserDefaults

    init(defaults: UserDefaults = UserDefaults.standard) {
        self.defaults = defaults
    }

    func saveParentName(name: String) {
        if name != "" {
            defaults.set(name, forKey: "parentName")
        }
    }
}
