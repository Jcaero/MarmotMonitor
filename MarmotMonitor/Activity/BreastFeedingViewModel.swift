//
//  BreastFeedingViewModel.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 12/12/2023.
//

import Foundation

protocol BreastFeedingDelegate: AnyObject {
    func updateTotalLabel(with texte: String)
}

final class BreastFeedingViewModel {
    private var rightTime = 0
    private var leftTime = 0
    private var totalTime: Int {
        return rightTime + leftTime
    }

    private weak var delegate: BreastFeedingDelegate?

    init(delegate: BreastFeedingDelegate?) {
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
        delegate?.updateTotalLabel(with: time.toTimeString())
    }
}
