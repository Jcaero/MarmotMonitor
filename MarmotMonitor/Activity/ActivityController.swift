//
//  ActivityController.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 22/12/2023.
//

import UIKit
/// ActivityController
/// This class is used to put date in activity controller
class ActivityController: BackGroundActivity {
    let separator: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()

    let timeLabel: UILabel = {
        let label = UILabel()
        label.setupDynamicTextWith(policeName: "Symbol", size: 25, style: .body)
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    let timePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .dateAndTime
        datePicker.maximumDate = Date()
        datePicker.tintColor = .label
        datePicker.backgroundColor = .clear
        return datePicker
    }()

    // MARK: - PROPERTIES
    let userDefaults = UserDefaultsManager()

    // MARK: - Cycle life
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupContraints()

        setupTimePicker()
    }

    // MARK: - Setup function
    private func setupViews() {
        [separator, timeLabel, timePicker].forEach {
            scrollArea.addSubview($0)
        }
    }

    private func setupContraints() {
        [separator, timeLabel, timePicker].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            timeLabel.topAnchor.constraint(equalTo: scrollArea.topAnchor),
            timeLabel.rightAnchor.constraint(equalTo: scrollArea.rightAnchor, constant: -20),
            timeLabel.leftAnchor.constraint(equalTo: scrollArea.leftAnchor, constant: 20),

            timePicker.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 15),
            timePicker.centerXAnchor.constraint(equalTo: scrollArea.centerXAnchor),
            timePicker.leftAnchor.constraint(greaterThanOrEqualTo: scrollArea.leftAnchor, constant: 20),

            separator.topAnchor.constraint(equalTo: timePicker.bottomAnchor, constant: 15),
            separator.centerXAnchor.constraint(equalTo: scrollArea.centerXAnchor),
            separator.widthAnchor.constraint(equalTo: scrollArea.widthAnchor, multiplier: 0.8),
            separator.heightAnchor.constraint(equalToConstant: 2)
        ])
    }

    func nextView() {
        self.dismiss(animated: true, completion: nil)
    }

    func alert(title: String, description: String) {
        let alertVC = UIAlertController(title: title, message: description, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }

    func setupTimePicker() {
        guard let birthDay = userDefaults.getBirthDay() else { return }

        timePicker.minimumDate = birthDay.toDate()
    }

}
