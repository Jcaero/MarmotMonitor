//
//  IconSettingViewModel.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 11/02/2024.
//

import UIKit

class IconSettingViewModel {
    private let userDefaultsManager: UserDefaultManagerProtocol!
    var iconeName: String?
    var gender: String {
        return userDefaultsManager.getGender() ?? ""
    }

    init(userDefaultsManager: UserDefaultManagerProtocol = UserDefaultsManager()) {
        self.userDefaultsManager = userDefaultsManager
    }

    func getBorderColor() -> CGColor {
        switch gender {
        case " garçon":
            return UIColor.colorForGradientStart.cgColor
        default:
            return UIColor.colorForGradientStartPink.cgColor
        }
    }

    func getIconeName() -> String {
        return userDefaultsManager.getAppIconName() ?? NIAppIconType.defaultIcon.name
    }

    func getIconeImageName() -> String {
        let iconeName = userDefaultsManager.getAppIconName() ?? NIAppIconType.defaultIcon.name
        return iconeName + "Image"
    }

    func saveIconeName(name: String) {
        userDefaultsManager.saveAppIconName(name)
    }

    func setIconeName(name: String?) {
        iconeName = name
    }
}
