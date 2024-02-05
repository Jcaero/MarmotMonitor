//
//  InformationViewModel.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 05/02/2024.
//

import Foundation
class InformationViewModel {
    private let userDefaultsManager: UserDefaultManagerProtocol!
    var babyName: String = ""
    var parentName: String = ""
    var birthDay: String = ""
    var gender: String = ""

    init(userDefaultsManager: UserDefaultManagerProtocol = UserDefaultsManager()) {
        self.userDefaultsManager = userDefaultsManager
    }

    func getUserInformation() {
        babyName = userDefaultsManager.getBabyName() ?? ""
        birthDay = userDefaultsManager.getBirthDay() ?? ""
        parentName = userDefaultsManager.getParentName() ?? ""
        gender = userDefaultsManager.getGender() ?? ""
    }
}
