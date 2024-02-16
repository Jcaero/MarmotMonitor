//
//  ApparenceSettingViewModel.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 13/02/2024.
//

import UIKit

final class ApparenceSettingViewModel {
    private let userDefaultsManager: UserDefaultManagerProtocol!

    var apparence: UIUserInterfaceStyle {
        return userDefaultsManager.getApparenceSetting()
    }

    var colorOfBackground: UIColor {
        switch userDefaultsManager.getGender() {
        case .girl:
            return .colorForGradientStartPink
        default:
            return .colorForGradientStart
        }
    }

    init(userDefaultsManager: UserDefaultManagerProtocol = UserDefaultsManager()) {
        self.userDefaultsManager = userDefaultsManager
    }

    func saveAparenceSetting(type: Int) {
        let localType : UIUserInterfaceStyle
        switch type {
        case 1:
            userDefaultsManager.saveApparenceSetting(.light)
            localType = .light
        case 2:
            userDefaultsManager.saveApparenceSetting(.dark)
            localType = .dark
        default:
            userDefaultsManager.saveApparenceSetting(.unspecified)
            localType = .unspecified
        }

        // apply the change to appplication
        if let keyWindow = UIApplication.shared.connectedScenes.compactMap({ $0 as? UIWindowScene }).flatMap({ $0.windows }).first(where: { $0.isKeyWindow }) {
            keyWindow.overrideUserInterfaceStyle = localType
        }
    }

    func getInitPositionOfSelected() -> Int {
        switch apparence {
        case .light:
            return 1
        case .dark:
            return 2
        default:
            return 0
        }
    }
}
