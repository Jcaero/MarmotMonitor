//
//  breastfeedingViewController.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 09/12/2023.
//

import UIKit

class BreastFeedingViewController: BackgroundViewController {
    let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "Heure"
        label.setupDynamicTextWith(policeName: "Symbol", size: 25, style: .body)
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = 0
        label.setAccessibility(with: .staticText, label: "heure de la tétée", hint: "")
        return label
    }()

    let timePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .dateAndTime
        datePicker.maximumDate = Date()
        datePicker.tintColor = .label
        datePicker.backgroundColor = .clear
        datePicker.setAccessibility(with: .selected, label: "", hint: "choisir l'heure de la tétée")
        return datePicker
    }()

    let timeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.setAccessibility(with: .staticText, label: "", hint: "")
        return stackView
    }()

    let rightBreastButton: UIButton = {
        let button = UIButton()
        button.setTitle("D", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = .clear
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.label.cgColor
        return button
    }()

    let leftBreastButton: UIButton = {
        let button = UIButton()
        button.setTitle("G", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = .clear
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.label.cgColor
        return button
    }()

    let timeLeftBreastLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.setupDynamicTextWith(policeName: "Symbol", size: 25, style: .body)
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = 0
        label.setAccessibility(with: .staticText, label: "", hint: "")
        return label
    }()

    let timeRightBreastLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.setupDynamicTextWith(policeName: "Symbol", size: 25, style: .body)
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = 0
        label.setAccessibility(with: .staticText, label: "", hint: "")
        return label
    }()

    let totalTimeBreastLabel: UILabel = {
        let label = UILabel()
        label.text = "Temps total: 0"
        label.setupDynamicTextWith(policeName: "Symbol", size: 25, style: .body)
        label.textColor = .label
        label.textAlignment = .center
        label.backgroundColor = .colorForBreastButton
        label.numberOfLines = 0
        label.layer.cornerRadius = 30
        label.clipsToBounds = true
        label.setAccessibility(with: .staticText, label: "", hint: "")
        return label
    }()

    let firstBreastLabel: UILabel = {
        let label = UILabel()
        label.text = "Premier sein ?"
        label.setupDynamicTextWith(policeName: "Symbol", size: 25, style: .body)
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = 0
        label.setAccessibility(with: .staticText, label: "Premier sein ?", hint: "")
        return label
    }()

    let firstBreastButton: UIButton = {
        let button = UIButton()
        button.setTitle("D", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = .colorForBreastButton
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        return button
    }()

    // MARK: - Cycle life
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupContraints()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        leftBreastButton.layer.cornerRadius = leftBreastButton.frame.width/2
        rightBreastButton.layer.cornerRadius = rightBreastButton.frame.width/2
    }

    // MARK: - Setup function

    private func setupViews() {
        
        [timeStackView, leftBreastButton, timeLeftBreastLabel, rightBreastButton, timeRightBreastLabel, totalTimeBreastLabel, firstBreastLabel, firstBreastButton].forEach {
            view.addSubview($0)
        }
        timeStackView.addArrangedSubview(timeLabel)
        timeStackView.addArrangedSubview(timePicker)
    }

    private func setupContraints() {
        [timeStackView,timeLabel, timePicker, leftBreastButton, timeLeftBreastLabel, rightBreastButton, timeRightBreastLabel, totalTimeBreastLabel, firstBreastLabel, firstBreastButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            timeStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            timeStackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            timeStackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20)
        ])

        NSLayoutConstraint.activate([
            rightBreastButton.topAnchor.constraint(equalTo: timeStackView.bottomAnchor, constant: 30),
            rightBreastButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: view.frame.width/4),
            rightBreastButton.widthAnchor.constraint(equalToConstant: view.frame.width/4),
            rightBreastButton.heightAnchor.constraint(equalTo: rightBreastButton.widthAnchor)
        ])

        NSLayoutConstraint.activate([
            leftBreastButton.topAnchor.constraint(equalTo: timeStackView.bottomAnchor, constant: 30),
            leftBreastButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -view.frame.width/4),
            leftBreastButton.widthAnchor.constraint(equalToConstant: view.frame.width/4),
            leftBreastButton.heightAnchor.constraint(equalTo: rightBreastButton.widthAnchor)
        ])

        NSLayoutConstraint.activate([
            timeLeftBreastLabel.topAnchor.constraint(equalTo: leftBreastButton.bottomAnchor, constant: 10),
            timeLeftBreastLabel.centerXAnchor.constraint(equalTo: leftBreastButton.centerXAnchor),
            timeLeftBreastLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4)
        ])

        NSLayoutConstraint.activate([
            timeRightBreastLabel.topAnchor.constraint(equalTo: rightBreastButton.bottomAnchor, constant: 10),
            timeRightBreastLabel.centerXAnchor.constraint(equalTo: rightBreastButton.centerXAnchor),
            timeRightBreastLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4)
        ])

        NSLayoutConstraint.activate([
            totalTimeBreastLabel.topAnchor.constraint(equalTo: timeRightBreastLabel.bottomAnchor, constant: 30),
            totalTimeBreastLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            totalTimeBreastLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            totalTimeBreastLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 100)
        ])

        NSLayoutConstraint.activate([
            firstBreastLabel.topAnchor.constraint(equalTo: totalTimeBreastLabel.bottomAnchor, constant: 30),
            firstBreastLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            firstBreastLabel.rightAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        NSLayoutConstraint.activate([
            firstBreastButton.centerYAnchor.constraint(equalTo: firstBreastLabel.centerYAnchor),
            firstBreastButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: view.frame.width/4),
            firstBreastButton.widthAnchor.constraint(equalToConstant: view.frame.width/6)
        ])
    }
}
