//
//  breastfeedingViewController.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 09/12/2023.
//

import UIKit

class BreastFeedingViewController: UIViewController {
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isScrollEnabled = true
        scrollView.backgroundColor = .clear
        return scrollView
    }()

    let scrollArea: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()

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

    let separator: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
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

    let rightBreastButton: UIButton = {
        let button = UIButton()
        button.setTitle("D", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = .clear
        button.layer.borderWidth = 10
        button.layer.borderColor = UIColor.duckBlue.cgColor
        return button
    }()

    let leftBreastButton: UIButton = {
        let button = UIButton()
        button.setTitle("G", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = .clear
        button.layer.borderWidth = 10
        button.layer.borderColor = UIColor.duckBlue.cgColor
        return button
    }()

    let timeLeftBreastLabel: UILabel = {
        let label = UILabel()
        label.text = "0 min"
        label.setupDynamicTextWith(policeName: "Symbol", size: 25, style: .body)
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = 0
        label.setAccessibility(with: .staticText, label: "", hint: "")
        return label
    }()

    let timeRightBreastLabel: UILabel = {
        let label = UILabel()
        label.text = "0 min"
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
        view.backgroundColor = .pastelBlueNew

        setupViews()
        setupContraints()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        leftBreastButton.layer.cornerRadius = leftBreastButton.frame.width/2
        rightBreastButton.layer.cornerRadius = rightBreastButton.frame.width/2
        firstBreastButton.layer.cornerRadius = firstBreastButton.frame.width/2
    }

    // MARK: - Setup function

    private func setupViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(scrollArea)

        [leftBreastButton, timeLeftBreastLabel, rightBreastButton, timeRightBreastLabel, totalTimeBreastLabel, firstBreastLabel, firstBreastButton, separator, timeLabel, timePicker].forEach {
            scrollArea.addSubview($0)
        }
    }

    private func setupContraints() {
        [timeLabel, timePicker,
         leftBreastButton, timeLeftBreastLabel,
         rightBreastButton, timeRightBreastLabel,
         totalTimeBreastLabel,
         firstBreastLabel, firstBreastButton,
         separator, 
         scrollView, scrollArea].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])

        NSLayoutConstraint.activate([
            scrollArea.topAnchor.constraint(equalTo: scrollView.topAnchor),
            scrollArea.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -10),
            scrollArea.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
            scrollArea.widthAnchor.constraint(equalToConstant: (view.frame.width - 20))
        ])

        NSLayoutConstraint.activate([
            rightBreastButton.topAnchor.constraint(equalTo: scrollArea.topAnchor, constant: view.frame.height/10),
            rightBreastButton.centerXAnchor.constraint(equalTo: scrollArea.centerXAnchor, constant: view.frame.width/4),
            rightBreastButton.widthAnchor.constraint(equalToConstant: view.frame.width/4),
            rightBreastButton.heightAnchor.constraint(equalTo: rightBreastButton.widthAnchor)
        ])

        NSLayoutConstraint.activate([
            leftBreastButton.topAnchor.constraint(equalTo: rightBreastButton.topAnchor),
            leftBreastButton.centerXAnchor.constraint(equalTo: scrollArea.centerXAnchor, constant: -view.frame.width/4),
            leftBreastButton.widthAnchor.constraint(equalToConstant: view.frame.width/4),
            leftBreastButton.heightAnchor.constraint(equalTo: leftBreastButton.widthAnchor)
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
            totalTimeBreastLabel.leftAnchor.constraint(equalTo: leftBreastButton.leftAnchor),
            totalTimeBreastLabel.rightAnchor.constraint(equalTo: rightBreastButton.rightAnchor),
            totalTimeBreastLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 100)
        ])

        NSLayoutConstraint.activate([
            separator.topAnchor.constraint(equalTo: totalTimeBreastLabel.bottomAnchor, constant: 30),
            separator.leftAnchor.constraint(equalTo: totalTimeBreastLabel.leftAnchor),
            separator.rightAnchor.constraint(equalTo: totalTimeBreastLabel.rightAnchor),
            separator.heightAnchor.constraint(equalToConstant: 1)
        ])

        NSLayoutConstraint.activate([
            timeLabel.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 30),
            timeLabel.rightAnchor.constraint(equalTo: scrollArea.rightAnchor, constant: -20),
            timeLabel.leftAnchor.constraint(equalTo: scrollArea.leftAnchor, constant: 20)
        ])

        NSLayoutConstraint.activate([
            timePicker.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 30),
            timePicker.rightAnchor.constraint(equalTo: scrollArea.rightAnchor, constant: -20),
            timePicker.leftAnchor.constraint(greaterThanOrEqualTo: scrollArea.leftAnchor, constant: 20)
        ])

        NSLayoutConstraint.activate([
            firstBreastLabel.topAnchor.constraint(equalTo: timePicker.bottomAnchor, constant: 30),
            firstBreastLabel.leftAnchor.constraint(equalTo: scrollArea.leftAnchor, constant: 20),
            firstBreastLabel.rightAnchor.constraint(equalTo: scrollArea.rightAnchor, constant: -20)
        ])

        NSLayoutConstraint.activate([
            firstBreastButton.topAnchor.constraint(equalTo: firstBreastLabel.bottomAnchor, constant: 10),
            firstBreastButton.rightAnchor.constraint(equalTo: scrollArea.rightAnchor, constant: -20),
            firstBreastButton.widthAnchor.constraint(equalToConstant: view.frame.width/6),
            firstBreastButton.heightAnchor.constraint(equalTo: firstBreastButton.widthAnchor),
            firstBreastLabel.bottomAnchor.constraint(equalTo: scrollArea.bottomAnchor, constant: 10)
        ])
    }
}
