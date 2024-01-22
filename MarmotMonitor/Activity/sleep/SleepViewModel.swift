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
    func nextView()
    func alert(title: String, description: String)
}

final class SleepViewModel {

    private weak var delegate: SleepDelegate?
    private var coreDataManager: MarmotMonitorSaveManager!

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

    private var sleepDuration: Int? {
        guard let start = sleepDate.first!, let end = sleepDate.last! else {return nil}
        guard start < end else {return nil}
        let durationInSeconds = end.timeIntervalSince(start)
        return Int(durationInSeconds)
    }

    init(delegate: SleepDelegate?, coreDataManager: MarmotMonitorSaveManager = MarmotMonitorSaveManager()) {
        self.delegate = delegate
        self.coreDataManager = coreDataManager
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
        guard let startDate = sleepDate.first!, let endDate = sleepDate.last! else {delegate?.updateDuration(with: "");return
        }

        guard startDate <= endDate else {
            showAlert(title: "Erreur", description: "Erreur de date");return
        }

        let duration = endDate.timeIntervalSince(startDate)
        delegate?.updateDuration(with: "\(duration.toStringWithHourAndMinute())")
    }

    private func isDateValid() -> Bool {
        guard let startDate = sleepDate.first!, let endDate = sleepDate.last! else {return false}
        return startDate <= endDate
    }

    // MARK: - Core Data
    func saveSleep() {
        guard let date = sleepDate.first!
        else {
            showAlert(title: "Erreur", description: "Aucune date rentrée")
            return
        }

        guard let sleepDuration = sleepDuration
        else {
            showAlert(title: "Erreur", description: "Aucune durée rentrée")
            return
        }

        coreDataManager.saveActivity(.sleep(duration: sleepDuration),
                                     date: date,
                                     onSuccess: { self.delegate?.nextView() },
                                     onError: { description in self.showAlert(title: "Erreur", description: description) })
    }

    // MARK: - Alert
    private func showAlert(title: String, description: String) {
        delegate?.alert(title: title, description: description)
    }
}
