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
    var saveIconName: String {
        return userDefaultsManager.getAppIconName() ?? NIAppIconType.defaultIcon.name
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

    // MARK: - Icon
    func setIcon() {
            if UIApplication.shared.supportsAlternateIcons {
                UIApplication.shared.setAlternateIconName(saveIconName) { error in
                    if let error = error {
                        print("Error setting alternate icon \(self.saveIconName ): \(error.localizedDescription)")
                    }
                }
            }
        }
}
