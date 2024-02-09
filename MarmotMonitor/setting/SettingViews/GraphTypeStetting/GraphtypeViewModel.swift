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

    func getGraphData() -> [GraphActivity] {
        var acti: [GraphActivity] = []

        let sleepMockDate = "07/01/2024 12:00".toDateWithTime() ?? Date()
        acti.append(GraphActivity(type: .sleep, color: .colorForSleep, timeStart: sleepMockDate, duration: 7200))

        let bottleMockDate = "07/01/2024 10:00".toDateWithTime() ?? Date()
        acti.append(GraphActivity(type: .bottle, color: .colorForMeal, timeStart: bottleMockDate, duration: 320))

        let diaperMockDate = "07/01/2024 16:00".toDateWithTime() ?? Date()
        acti.append(GraphActivity(type: .diaper, color: .colorForDiaper, timeStart: diaperMockDate, duration: 320))

        return acti
    }
}
