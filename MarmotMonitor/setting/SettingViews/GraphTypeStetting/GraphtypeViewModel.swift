//
//  GraphtypeViewModel.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 07/02/2024.
//

import Foundation
final class GraphtypeViewModel {
    private let userDefaultsManager: UserDefaultManagerProtocol!

    var graphType: [(String, Bool)] = [("Pixel", false), ("Barre",false), ("Ligne",false)]

    // MARK: - Initializer
    init(userDefaultsManager: UserDefaultManagerProtocol = UserDefaultsManager()) {
        self.userDefaultsManager = userDefaultsManager
        initGraphtype()
    }

    private func initGraphtype() {
        guard let graphType = getGraphType() else { return }
        switch graphType {
        case .round:
            self.graphType[0].1 = true
        case .rod:
            self.graphType[1].1 = true
        case .ligne:
            self.graphType[2].1 = true
        }
    }

    private func getGraphType() -> GraphType? {
        return userDefaultsManager.getGraphType()
    }

    private func setGraphType(graphType: GraphType) {
        userDefaultsManager.saveGraphType(graphType)
    }

    func graphTypeSelected(index: Int) {
        graphType = graphType.map { ($0.0, false) }
        graphType[index].1 = true
    }

    func saveGraphType() {
        guard let index = graphType.firstIndex(where: { $0.1 == true }) else { return }
        switch graphType[index].0 {
        case "Pixel":
            setGraphType(graphType: .round)
        case "Barre":
            setGraphType(graphType: .rod)
        case "Ligne":
            setGraphType(graphType: .ligne)
        default:
            break
        }
    }
}
