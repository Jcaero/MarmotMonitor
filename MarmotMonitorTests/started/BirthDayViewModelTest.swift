//
//  BirthDayViewModelTest.swift
//  MarmotMonitorTests
//
//  Created by pierrick viret on 26/11/2023.
//

import XCTest
@testable import MarmotMonitor

class BirthDayViewModelTest: XCTestCase {

    private var viewModel: BirthDayViewModel!
    private var defaults: UserDefaults!

    private var alerteTitle: String?
    private var alerteDesciption: String?
    private var pushNavigation: Bool?

    override func setUp() {
        super.setUp()
        defaults = UserDefaults(suiteName: #file)
        viewModel = BirthDayViewModel(defaults: defaults, delegate: self)
        pushNavigation = false
    }

    override func tearDown() {
        defaults.removePersistentDomain(forName: #file)
        super.tearDown()
    }

    func testBabyHavePickerDate_WhenSaveBabyDate_DateHasBeenSave() {
        let testBabyDate = "25/11/2023"
        let testDate = testBabyDate.toDate()

        viewModel.save(date: .date(testDate!))

        let savedName = defaults.string(forKey: UserInfoKey.birthDay.rawValue)
        XCTAssertEqual(savedName, testBabyDate)
    }

    func testBabyHaveDate_WhenSaveBabyDate_DateHasBeenSave() {
        let testBabyDate = "25/11/2023"

        viewModel.save(date: .stringDate(testBabyDate))

        let savedName = defaults.string(forKey: UserInfoKey.birthDay.rawValue)
        XCTAssertEqual(savedName, testBabyDate)
    }

    func testBabyHaveWrongDate_WhenSaveBabyDate_ShowAlert() {
        let testBabyDate = "25/18/2023"

        viewModel.save(date: .stringDate(testBabyDate))

        XCTAssertEqual(alerteTitle, "Erreur")
        XCTAssertEqual(alerteDesciption, "Le format de la date de naissance n'est pas valide")
    }

    func testBabyHaveLettre_WhenSaveBabyDate_ShowAlert() {
        let testBabyDate = "test"

        viewModel.save(date: .stringDate(testBabyDate))

        XCTAssertEqual(alerteTitle, "Erreur")
        XCTAssertEqual(alerteDesciption, "Le format de la date de naissance n'est pas valide")
    }

    func testBabyHaveNil_WhenSaveBabyDate_ShowAlert() {
        let testBabyDate = ""

        viewModel.save(date: .stringDate(testBabyDate))

        XCTAssertEqual(alerteTitle, "Erreur")
        XCTAssertEqual(alerteDesciption, "Le format de la date de naissance n'est pas valide")
    }

    func testBabyHaveFutureDate_WhenSaveBabyDate_ShowAlert() {
        let testDate = Date()
        let datePlusTenDays = Calendar.current.date(byAdding: .day, value: 10, to: testDate)

        viewModel.save(date: .date(datePlusTenDays!))

        XCTAssertEqual(alerteTitle, "Erreur")
        XCTAssertEqual(alerteDesciption, "Veuillez entrer une date de naissance antérieure à la date d'aujourd'hui.")
    }
}

extension BirthDayViewModelTest: BirthDayDelegate {
    func showAlert(title: String, description: String) {
        alerteTitle = title
        alerteDesciption = description
    }

    func pushToNextView() {
        pushNavigation = true
    }
}
