//
//  BreastFeedingChronoViewModel.swift
//  MarmotMonitorTests
//
//  Created by pierrick viret on 16/12/2023.
//

import Foundation
import XCTest
@testable import MarmotMonitor

class BreastFeedingChronoViewModelTest: XCTestCase {

    private var viewModel: BreastFeedingChronoViewModel!

    private var leftTime = "00:00"
    private var rightTime = "00:00"
    private var totalTime = "00:00"
    
    private var leftState: MarmotMonitor.ButtonState!
    private var rightState: MarmotMonitor.ButtonState!

    override func setUp() {
        super.setUp()
        viewModel = BreastFeedingChronoViewModel(delegate: self)
        leftTime = "00:00"
        rightTime = "00:00"
        totalTime = "00:00"
    }

    override func tearDown() {
        super.tearDown()
        viewModel = nil
    }

    func testTimerIsOFF_WhenTappeLeftButton_TimeStarted() {
        let expectation = XCTestExpectation(description: "Le timer augmente leftTime et appelle le delegate")

        viewModel.buttonPressed(.left)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.1) {
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 2.0)

        XCTAssertEqual(leftTime, "00:01")
    }

    func testTimerIsOFF_WhenTappeRightButton_TimeStarted() {
        let expectation = XCTestExpectation(description: "Le timer augmente rightTime et appelle le delegate")

        viewModel.buttonPressed(.right)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.1) {
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 2.0)

        XCTAssertEqual(rightTime, "00:01")
    }

    func testTimerIsOFF_WhenTappeRightButtonAndWait5s_TimeIsTen() {
        let expectation = XCTestExpectation(description: "Le timer augmente rightTime et appelle le delegate")

        viewModel.buttonPressed(.right)

        DispatchQueue.main.asyncAfter(deadline: .now() + 5.1) {
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 6.0)

        XCTAssertEqual(rightTime, "00:05")
    }

    func testRightTimerStarted5sAgo_WhenStopTimer_TimeIsStopped() {
        let expectation = XCTestExpectation(description: "Le timer augmente rightTime et appelle le delegate")

        viewModel.buttonPressed(.right)

        DispatchQueue.main.asyncAfter(deadline: .now() + 5.1) {
            self.viewModel.buttonPressed(.right)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 7.1) {
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 8.0)

        XCTAssertEqual(rightTime, "00:05")
    }

    func testRightTimerStarted5sAgo_WhenStopTimerWait2sAndRestartd_TimeIsRestart() {
        let expectation = XCTestExpectation(description: "Le timer augmente rightTime et appelle le delegate")

        viewModel.buttonPressed(.right)

        DispatchQueue.main.asyncAfter(deadline: .now() + 5.1) {
            self.viewModel.buttonPressed(.right)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 7.1) {
            self.viewModel.buttonPressed(.right)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 9.1) {
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 10.0)

        XCTAssertEqual(rightTime, "00:07")
    }

    func testTotalTimeIsZero_WhenTimerStarted_TotalTimeIsNotZero() {
        let expectation = XCTestExpectation(description: "Le timer augmente rightTime et appelle le delegate")

        viewModel.buttonPressed(.right)

        DispatchQueue.main.asyncAfter(deadline: .now() + 5.1) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 7.0)

        XCTAssertEqual(rightTime, "00:05")
        XCTAssertEqual(totalTime, "00:05")
    }

    func testTotalTimeIsZero_When2TimerStarted_TotalTimeIsNotZero() {
        let expectation = XCTestExpectation(description: "Les timers augmentent et appelle le delegate")

        viewModel.buttonPressed(.right)
        rightState = .start

        DispatchQueue.main.asyncAfter(deadline: .now() + 3.1) {
            self.viewModel.buttonPressed(.left)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 5.1) {
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 7.0)

        XCTAssertEqual(rightTime, "00:03")
        XCTAssertEqual(leftTime, "00:02")
        XCTAssertEqual(totalTime, "00:05")
        XCTAssertEqual(rightState, .stop)
    }

    func testTotalTimeIsZero_WhenTimerStartedLeftAfterRight_TotalTimeIsNotZero() {
        let expectation = XCTestExpectation(description: "Les timers augmentent et appelle le delegate")

        viewModel.buttonPressed(.left)
        leftState = .start

        DispatchQueue.main.asyncAfter(deadline: .now() + 3.1) {
            self.viewModel.buttonPressed(.right)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 5.1) {
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 7.0)

        XCTAssertEqual(leftTime, "00:03")
        XCTAssertEqual(rightTime, "00:02")
        XCTAssertEqual(totalTime, "00:05")
        XCTAssertEqual(leftState, .stop)
    }

    func testTotalTimeIsZero_WhenLeftManualSetPressed_TotalTimeIsNotZero() {

        viewModel.manualButtonPressed(.left, time: 25)

        XCTAssertEqual(leftTime, "25:00")
        XCTAssertEqual(rightTime, "00:00")
        XCTAssertEqual(totalTime, "25:00")
    }

    func testTotalTimeIsZero_WhenRightManualSetPressed_TotalTimeIsNotZero() {

        viewModel.manualButtonPressed(.right, time: 25)

        XCTAssertEqual(leftTime, "00:00")
        XCTAssertEqual(rightTime, "25:00")
        XCTAssertEqual(totalTime, "25:00")
    }
}

extension BreastFeedingChronoViewModelTest: BreastFeedingChronoDelegate {
    func updateRightButtonImage(with state: MarmotMonitor.ButtonState) {
        rightState = state
    }

    func updateLeftButtonImage(with state: MarmotMonitor.ButtonState) {
        leftState = state
    }

    func updateTotalTimeLabel(with text: String) {
        totalTime = text
    }

    func updateRightTimeLabel(with text: String) {
        rightTime = text
    }

    func updateLeftTimeLabel(with text: String) {
        leftTime = text
    }
}
