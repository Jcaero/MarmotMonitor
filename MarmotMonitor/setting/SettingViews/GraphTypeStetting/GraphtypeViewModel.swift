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
        let graph = userDefaultsManager.getGraphType()
        switch graph {
        case GraphType.round.description:
            return .round
        case GraphType.ligne.description:
            return .ligne
        case GraphType.rod.description:
            return .rod
        default:
            return nil
        }
    }

    func setGraphType(graphType: GraphType) {
        userDefaultsManager.saveGraphType(graphType)
    }
}
