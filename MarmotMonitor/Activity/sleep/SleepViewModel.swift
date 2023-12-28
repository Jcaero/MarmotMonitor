//
//  SleepViewController.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 28/12/2023.
//

import Foundation

protocol SleepDelegate: AnyObject {
    func updateData()
}

final class SleepViewModel {

    private weak var delegate: SleepDelegate?

    var selectedLabel: Int = 0
    var dateData: [String] = ["Pas encore de date","Pas encore de date"]

    init(delegate: SleepDelegate?) {
        self.delegate = delegate
    }

    // MARK: - Function
    func setDate(with date: Date) {
        dateData[selectedLabel] = date.toStringWithTimeAndDayMonthYear()
        delegate?.updateData()
    }

    func setSelectedLabel(with tag: Int) {
        selectedLabel = tag
    }
}
