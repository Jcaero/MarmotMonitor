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
        label.text = "Heure du debut"
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
        button.setupDynamicTextWith(policeName: "Symbol", size: 25, style: .body)
        button.setTitleColor(.label, for: .normal)
        button.contentVerticalAlignment = .fill
        button.backgroundColor = .clear
        button.layer.borderWidth = 8
        button.layer.borderColor = UIColor.duckBlue.cgColor
        return button
    }()

    let leftBreastButton: UIButton = {
        let button = UIButton()
        button.setTitle("G", for: .normal)
        button.setupDynamicTextWith(policeName: "Symbol", size: 25, style: .body)
        button.setTitleColor(.label, for: .normal)
        button.contentVerticalAlignment = .fill
        button.backgroundColor = .clear
        button.layer.borderWidth = 8
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
        button.setupDynamicTextWith(policeName: "Symbol", size: 20, style: .body)
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = .colorForBreastButton
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        return button
    }()

    let picker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.backgroundColor = .white
        picker.datePickerMode = .countDownTimer
        picker.preferredDatePickerStyle = .wheels
        return picker
    }()

    let validePickerButton: UIButton = {
        let button = UIButton()
        button.setTitle("Valider", for: .normal)
        button.setupDynamicTextWith(policeName: "Symbol", size: 20, style: .body)
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = .colorForBreastButton
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        return button
    }()

    let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fillProportionally
        view.spacing = 20
        return view
    }()

    // MARK: - PROPERTIES
    var buttonWidthConstraint: NSLayoutConstraint?
    var firstBreastButtonCenterXContraint: NSLayoutConstraint?

    // MARK: - Cycle life
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .pastelBlueNew

        setupViews()
        setupContraints()
        traitCollectionDidChange(nil)
        hiddenPicker()
        setupActionButton()
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

        [leftBreastButton, timeLeftBreastLabel, rightBreastButton, timeRightBreastLabel, stackView, firstBreastLabel, firstBreastButton, separator, timeLabel, timePicker].forEach {
            scrollArea.addSubview($0)
        }

        stackView.addArrangedSubview(picker)
        stackView.addArrangedSubview(validePickerButton)
        stackView.addArrangedSubview(totalTimeBreastLabel)
    }

    private func setupContraints() {
        [timeLabel, timePicker,
         leftBreastButton, timeLeftBreastLabel,
         rightBreastButton, timeRightBreastLabel,
         totalTimeBreastLabel,
         firstBreastLabel, firstBreastButton,
         separator, stackView, validePickerButton,
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
            timeLabel.topAnchor.constraint(equalTo: scrollArea.topAnchor, constant: view.frame.height/10),
            timeLabel.rightAnchor.constraint(equalTo: scrollArea.rightAnchor, constant: -20),
            timeLabel.leftAnchor.constraint(equalTo: scrollArea.leftAnchor, constant: 20)
        ])

        NSLayoutConstraint.activate([
            timePicker.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 30),
            timePicker.centerXAnchor.constraint(equalTo: scrollArea.centerXAnchor),
            timePicker.leftAnchor.constraint(greaterThanOrEqualTo: scrollArea.leftAnchor, constant: 20)
        ])

        NSLayoutConstraint.activate([
            separator.topAnchor.constraint(equalTo: timePicker.bottomAnchor, constant: 30),
            separator.leftAnchor.constraint(equalTo: totalTimeBreastLabel.leftAnchor),
            separator.rightAnchor.constraint(equalTo: totalTimeBreastLabel.rightAnchor),
            separator.heightAnchor.constraint(equalToConstant: 1)
        ])

        buttonWidthConstraint = rightBreastButton.widthAnchor.constraint(equalToConstant: view.frame.width/4)
        NSLayoutConstraint.activate([
            rightBreastButton.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 30),
            rightBreastButton.centerXAnchor.constraint(equalTo: scrollArea.centerXAnchor, constant: view.frame.width/4),
            buttonWidthConstraint!,
            rightBreastButton.heightAnchor.constraint(equalTo: rightBreastButton.widthAnchor)
        ])

        NSLayoutConstraint.activate([
            leftBreastButton.topAnchor.constraint(equalTo: rightBreastButton.topAnchor),
            leftBreastButton.centerXAnchor.constraint(equalTo: scrollArea.centerXAnchor, constant: -view.frame.width/4),
            leftBreastButton.widthAnchor.constraint(equalTo: rightBreastButton.widthAnchor),
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
            stackView.topAnchor.constraint(equalTo: timeRightBreastLabel.bottomAnchor, constant: 30),
            stackView.leftAnchor.constraint(equalTo: leftBreastButton.leftAnchor),
            stackView.rightAnchor.constraint(equalTo: rightBreastButton.rightAnchor),
            totalTimeBreastLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 100),
            picker.heightAnchor.constraint(equalToConstant: 150),
            validePickerButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 50)
        ])

        NSLayoutConstraint.activate([
            firstBreastLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 30),
            firstBreastLabel.leftAnchor.constraint(equalTo: scrollArea.leftAnchor, constant: 20),
            firstBreastLabel.rightAnchor.constraint(equalTo: scrollArea.rightAnchor, constant: -20)
        ])

        NSLayoutConstraint.activate([
            firstBreastButton.topAnchor.constraint(equalTo: firstBreastLabel.bottomAnchor, constant: 10),
            firstBreastButton.centerXAnchor.constraint(equalTo: scrollArea.centerXAnchor),
            firstBreastButton.widthAnchor.constraint(equalTo: (rightBreastButton.widthAnchor), multiplier: 0.8),
            firstBreastButton.heightAnchor.constraint(equalTo: firstBreastButton.widthAnchor),
            firstBreastLabel.bottomAnchor.constraint(equalTo: scrollArea.bottomAnchor, constant: -100)
        ])
    }

    private func setupActionButton() {
        let action = UIAction { _ in
            self.hiddenPicker()
        }
        validePickerButton.addAction(action, for: .touchUpInside)

        let actionLeft = UIAction { _ in
            if self.leftBreastButton.backgroundColor == .duckBlue {
                self.leftBreastButton.backgroundColor = .clear
                self.hiddenPicker()
            } else {
                self.leftBreastButton.backgroundColor = .duckBlue
                self.showPicker()
            }
        }
        leftBreastButton.addAction(actionLeft, for: .touchUpInside)
    }

    // MARK: - Actions Picker
    private func hiddenPicker() {
        UIView.animate(withDuration: 0.5) {
            self.picker.isHidden = true
            self.validePickerButton.isHidden = true
        }
    }

    private func showPicker() {
        UIView.animate(withDuration: 0.4) {
            self.picker.isHidden = false
            self.validePickerButton.isHidden = false
        }
    }


}

// MARK: - Accesibility
extension BreastFeedingViewController {

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        let currentCategory = traitCollection.preferredContentSizeCategory
        let previousCategory = previousTraitCollection?.preferredContentSizeCategory

        guard currentCategory != previousCategory else { return }
        let isAccessibilityCategory = currentCategory.isAccessibilityCategory
        setupWidthContraintWith(height: isAccessibilityCategory ? view.frame.width/3 : view.frame.width/4)
    }

    func setupWidthContraintWith (height: CGFloat) {
        buttonWidthConstraint?.constant = height
        view.layoutIfNeeded()
    }
}
