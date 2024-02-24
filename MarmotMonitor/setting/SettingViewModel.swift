//
//  SettingViewModel.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 05/02/2024.
//

import UIKit
final class SettingViewModel {
    private let userDefaultsManager: UserDefaultManagerProtocol!

    var babyName: String {
        return userDefaultsManager.getBabyName() ?? ""
    }

    var parentName: String {
        let parent = userDefaultsManager.getParentName() ?? ""
        let gender = userDefaultsManager.getGender().description

        guard parent != "" else {return ""}
        switch gender {
        case Gender.boy.description:
            return "Fils de " + parent
        case Gender.girl.description:
            return "Fille de " + parent
        default:
            return "Parent: " + parent
        }
    }

    var birthDay: String {
        var day = userDefaultsManager.getBirthDay() ?? ""
        if day != "" {
            day = "Né le: " + day
        }
        return day
    }

    var graphType: GraphType {
        return userDefaultsManager.getGraphType() ?? .round
    }

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

    private var coreDataManager: MarmotMonitorSaveManager!

    // MARK: - INIT
    init(userDefaultsManager: UserDefaultManagerProtocol = UserDefaultsManager(), coreDataManager: MarmotMonitorSaveManager = MarmotMonitorSaveManager()) {
        self.userDefaultsManager = userDefaultsManager
        self.coreDataManager = coreDataManager
    }

    func clearCoreData() {
        coreDataManager.clearDatabase()
    }
}
