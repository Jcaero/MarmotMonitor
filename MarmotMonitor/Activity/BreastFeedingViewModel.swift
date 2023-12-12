//
//  BreastFeedingViewModel.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 12/12/2023.
//

import Foundation

protocol BreastFeedingDelegate: AnyObject {
    func updateRightLabel(with texte: String)
    func updateLeftLabel(with texte: String)
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
    func storeSelectedRow(picker: Double, for breast: String) {
        let time = Int(picker)
        switch breast {
        case "D":
            rightTime = time
            delegate?.updateRightLabel(with: time.toTimeString())
        case "G":
            leftTime = time
            delegate?.updateLeftLabel(with: time.toTimeString())
        default: break
        }
        delegate?.updateTotalLabel(with: totalTime.toTimeString())
    }
}
