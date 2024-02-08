//
//  GraphtypeViewModel.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 07/02/2024.
//

import Foundation
class GraphtypeViewModel {
    private let userDefaultsManager: UserDefaultManagerProtocol!

    // MARK: - Initializer
    init(userDefaultsManager: UserDefaultManagerProtocol = UserDefaultsManager()) {
        self.userDefaultsManager = userDefaultsManager
    }

    func getGraphType() -> GraphType? {
        return userDefaultsManager.getGraphType()
    }

    func setGraphType(graphType: GraphType) {
        userDefaultsManager.saveGraphType(graphType)
    }
}
