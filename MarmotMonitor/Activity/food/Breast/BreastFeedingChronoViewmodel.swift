//
//  BreastFeedingChronoViewmodel.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 16/12/2023.
//

import Foundation

protocol BreastFeedingChronoDelegate: AnyObject {
    func updateRightTimeLabel(with text: String)
    func updateLeftTimeLabel(with text: String)
    func updateTotalTimeLabel(with text: String)
    func updateRightButtonImage(with state: ButtonState)
    func updateLeftButtonImage(with state: ButtonState)
}

final class BreastFeedingChronoViewModel {
    private var rightTime = 0 {
        didSet { updateDelegateWithTime(rightTime, position: .right)
            updateTotalTime()}
    }
    private var leftTime = 0 {
        didSet { updateDelegateWithTime(leftTime, position: .left)
            updateTotalTime()}
    }
    private var totalTime: Int {
        return rightTime + leftTime
    }

    private var rightTimer: Timer?
    private var leftTimer: Timer?

    private weak var delegate: BreastFeedingChronoDelegate?

    init(delegate: BreastFeedingChronoDelegate?) {
        self.delegate = delegate
    }

    // MARK: - Function
    func buttonPressed(_ position: Position) {
        switch position {
        case .left:
            setStopImageToButton(of: rightTimer)
            toggleTimer(&leftTimer, otherTimer: &rightTimer, incrementTime: { self.leftTime += 1 })

        case .right:
            setStopImageToButton(of: leftTimer)
            toggleTimer(&rightTimer, otherTimer: &leftTimer, incrementTime: { self.rightTime += 1 })

        }
    }

    func resetButtonPressed() {
        razTimer(&leftTimer, time: &leftTime)
        razTimer(&rightTimer, time: &rightTime)
    }

    func manualButtonPressed(_ position: Position, time: Int) {
        switch position {
        case .left:
            razTimer(&leftTimer, time: &leftTime)
            delegate?.updateLeftButtonImage(with: .stop)
            leftTime = time*60
        case .right:
            razTimer(&rightTimer, time: &rightTime)
            delegate?.updateRightButtonImage(with: .stop)
            rightTime = time*60
        }
    }

    // MARK: - Helper Functions
    private func toggleTimer(_ timer: inout Timer?, otherTimer: inout Timer?, incrementTime: @escaping () -> Void) {
        if timer != nil {
            stopTimer(&timer)
        } else {
            stopTimer(&otherTimer)
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in incrementTime() }
        }
    }

    private func stopTimer(_ timer: inout Timer?) {
        if let existingTimer = timer {
            existingTimer.invalidate()
            timer = nil
        }
    }

    private func setStopImageToButton(of timer: Timer?) {
        guard let description = timer else { return }
        switch description {
        case leftTimer:
            delegate?.updateLeftButtonImage(with: .stop)
        case rightTimer:
            delegate?.updateRightButtonImage(with: .stop)
        default: break
        }
    }

    private func razTimer(_ timer: inout Timer?, time: inout Int) {
        timer?.invalidate()
        timer = nil
        time = 0
    }

    // MARK: - Delegate
    private func updateDelegateWithTime(_ time: Int, position: Position) {
        let text = formatTimeString(time)
        switch position {
        case .left:
            delegate?.updateLeftTimeLabel(with: text)
        case .right:
            delegate?.updateRightTimeLabel(with: text)
        }
    }

    private func updateTotalTime() {
        let text = formatTimeString(totalTime)
        delegate?.updateTotalTimeLabel(with: text)
    }

    // MARK: - Format Time
    private func formatTimeString(_ totalSeconds: Int) -> String {
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

enum Position {
    case left
    case right
}

enum ButtonState {
    case start
    case stop
}
