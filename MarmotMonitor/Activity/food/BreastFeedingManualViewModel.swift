//
//  BreastFeedingViewModel.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 12/12/2023.
//

import Foundation

protocol BreastFeedingManualDelegate: AnyObject {
    func updateTotalLabel(with text: String)
}

final class BreastFeedingManualViewModel {
    private var rightTime = 0
    private var leftTime = 0
    private var totalTime: Int {
        return rightTime + leftTime
    }

    private weak var delegate: BreastFeedingManualDelegate?

    init(delegate: BreastFeedingManualDelegate?) {
        self.delegate = delegate
    }

    // MARK: - function
    func storeSelected(time: Int, for breast: String) {
        switch breast {
        case "D":
            rightTime = time
        case "G":
            leftTime = time
        default: break
        }
        delegate?.updateTotalLabel(with: totalTime.toTimeString())
    }
}
