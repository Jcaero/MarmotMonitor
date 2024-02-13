//
//  SettingViewModel.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 05/02/2024.
//

import UIKit

class SettingViewModel {
    private let userDefaultsManager: UserDefaultManagerProtocol!
    var babyName: String = ""
    var parentName: String = ""
    var birthDay: String = ""
    var graphType: GraphType = .round
    var iconImageName: String {
        let iconeName = userDefaultsManager.getAppIconName() ?? NIAppIconType.defaultIcon.name
        return iconeName + "Image"
    }

    var apparenceStyle: String {
        let apparence = userDefaultsManager.getApparenceSetting()
        switch apparence {
        case .dark:
            return "Sombre"
        case .light:
            return "Clair"
        default:
            return "Auto"
        }
    }

    init(userDefaultsManager: UserDefaultManagerProtocol = UserDefaultsManager()) {
        self.userDefaultsManager = userDefaultsManager
    }

    func getUserInformation() {
        babyName = userDefaultsManager.getBabyName() ?? ""
        let day = userDefaultsManager.getBirthDay() ?? ""
        if day != "" {
            birthDay = "Né le: " + day
        }

        let parent = userDefaultsManager.getParentName() ?? ""
        let gender = userDefaultsManager.getGender() ?? ""

        guard parent != "" else {return}
        switch gender {
        case Gender.boy.description:
            parentName = "Fils de " + parent
        case Gender.girl.description:
            parentName = "Fille de " + parent
        default:
            parentName = "Parent: " + parent
        }

        graphType = userDefaultsManager.getGraphType() ?? .round
    }
}
