//
//  SleepViewController.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 28/12/2023.
//

import Foundation

protocol SleepDelegate: AnyObject {
    func updateData()
    func updateDuration(with duration: String)
}

final class SleepViewModel {

    private weak var delegate: SleepDelegate?

    private var selectedLabel: Int = 0

    var sleepData: [String] {
        var firstDate = "Pas encore de date"
        var secondDate = "Pas encore de date"
        if sleepDate.first != nil && sleepDate.first is Date {
            firstDate = sleepDate.first!!.toStringWithTimeAndDayMonthYear()
        }

        if sleepDate.last != nil && sleepDate.last is Date {
            secondDate = sleepDate.last!!.toStringWithTimeAndDayMonthYear()
        }
        return [firstDate, secondDate]
    }

    private var sleepDate: [Date?] = [nil, nil]

    init(delegate: SleepDelegate?) {
        self.delegate = delegate
    }

    // MARK: - Function
    func setDate(with date: Date) {
        guard selectedLabel >= 0, selectedLabel < sleepDate.count else {return}
        sleepDate[selectedLabel] = date
        delegate?.updateData()
        updateDuration()
    }

    func clearDate() {
        if selectedLabel >= 0 && selectedLabel < sleepDate.count {
            sleepDate[selectedLabel] = nil
            delegate?.updateData()
            updateDuration()
        }
    }

    func setSelectedLabel(with tag: Int) {
        selectedLabel = tag
    }

    private func updateDuration() {
        guard let startDate = sleepDate.first!, let endDate = sleepDate.last! else {delegate?.updateDuration(with: "");return}

        guard startDate <= endDate else { delegate?.updateDuration(with: "erreur de date"); return}

        let duration = endDate.timeIntervalSince(startDate)
        delegate?.updateDuration(with: "\(duration.toStringWithHourAndMinute())")
    }
}
