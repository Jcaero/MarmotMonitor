//
//  Personn.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 04/12/2023.
//

import Foundation

struct Person {
    var name: String
    var gender: String?
    var parentName: String?
    var birthDay: String?

    init(name: String) {
        self.name = name
    }

    init(name: String, gender: String?, parentName: String?, birthDay: String?) {
        self.name = name
        self.gender = gender
        self.parentName = parentName
        self.birthDay = birthDay
    }
}
