//
//  breastfeedingViewController.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 09/12/2023.
//

import UIKit

class BreastFeedingController: UIViewController {
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

    let leftBreastLabel: UILabel = {
        let label = UILabel()
        label.text = "Sein Gauche"
        label.setupDynamicTextWith(policeName: "Symbol", size: 25, style: .body)
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = 0
        label.setAccessibility(with: .staticText, label: "", hint: "")
        return label
    }()

    let rightBreastLabel: UILabel = {
        let label = UILabel()
        label.text = "Sein Droit"
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
        label.layer.cornerRadius = 15
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

    let firstBreastSegmented: UISegmentedControl = {
        let segmented = UISegmentedControl(items: ["Gauche", "Droite"])
        segmented.backgroundColor = .clear
        segmented.tintColor = .colorForBreastButton
        segmented.selectedSegmentIndex = 0 // Gauche
        return segmented
    }()

    let rightPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.backgroundColor = .clear
        picker.layer.cornerRadius = 20
        return picker
    }()

    let leftPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.backgroundColor = .clear
        picker.layer.cornerRadius = 20
        return picker
    }()

    let cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Annuler", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.setupDynamicTextWith(policeName: "Symbol", size: 25, style: .body)
        return button
    }()

    let valideButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "checkmark"), for: .normal)
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
    var isSelectedBreastButton = ""
    var selectedTime = 0

    var viewModel: BreastFeedingViewModel!

    // MARK: - Cycle life
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .pastelBlueNew

        setupViews()
        setupContraints()
        traitCollectionDidChange(nil)

        // MARK: - Delegate
        [rightPicker, leftPicker].forEach {
            $0.delegate = self
            $0.dataSource = self
        }

        viewModel = BreastFeedingViewModel(delegate: self)
    }

    // MARK: - Setup function

    private func setupViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(scrollArea)

        [timeLabel, timePicker, separator, stackView, rightPicker, leftPicker, valideButton, cancelButton  ].forEach {
            scrollArea.addSubview($0)
        }

        [totalTimeBreastLabel, firstBreastLabel, firstBreastSegmented].forEach {
            stackView.addArrangedSubview($0)
        }
    }

    private func setupContraints() {
        [timeLabel, timePicker, separator, stackView,
        rightPicker, leftPicker,
         valideButton, cancelButton, totalTimeBreastLabel,
         firstBreastLabel, firstBreastSegmented,
        scrollArea, scrollView].forEach {
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
            scrollArea.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 10),
            scrollArea.widthAnchor.constraint(equalToConstant: (view.frame.width - 20))
        ])

        NSLayoutConstraint.activate([
            timeLabel.topAnchor.constraint(equalTo: scrollArea.topAnchor, constant: view.frame.height/20),
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
            separator.leftAnchor.constraint(equalTo: totalTimeBreastLabel.leftAnchor, constant: 40),
            separator.rightAnchor.constraint(equalTo: totalTimeBreastLabel.rightAnchor, constant: -40),
            separator.heightAnchor.constraint(equalToConstant: 2)
        ])

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 30),
            stackView.centerXAnchor.constraint(equalTo: scrollArea.centerXAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollArea.widthAnchor),
            totalTimeBreastLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 50)
        ])

        NSLayoutConstraint.activate([
            rightPicker.topAnchor.constraint(equalTo: stackView.bottomAnchor),
            rightPicker.leftAnchor.constraint(equalTo: scrollArea.centerXAnchor),
            rightPicker.rightAnchor.constraint(equalTo: scrollArea.rightAnchor)
        ])

        NSLayoutConstraint.activate([
            leftPicker.topAnchor.constraint(equalTo: rightPicker.topAnchor),
            leftPicker.leftAnchor.constraint(equalTo: scrollArea.leftAnchor),
            leftPicker.rightAnchor.constraint(equalTo: scrollArea.centerXAnchor)
        ])

        NSLayoutConstraint.activate([
            cancelButton.topAnchor.constraint(equalTo: leftPicker.bottomAnchor, constant: 30),
            cancelButton.leftAnchor.constraint(equalTo: scrollArea.leftAnchor),
            cancelButton.rightAnchor.constraint(equalTo: scrollArea.centerXAnchor)
        ])

        NSLayoutConstraint.activate([
            valideButton.topAnchor.constraint(equalTo: rightPicker.bottomAnchor, constant: 30),
            valideButton.centerXAnchor.constraint(equalTo: rightPicker.centerXAnchor),
            valideButton.widthAnchor.constraint(equalTo: valideButton.heightAnchor),
            valideButton.heightAnchor.constraint(equalTo: cancelButton.heightAnchor),
            valideButton.bottomAnchor.constraint(equalTo: scrollArea.bottomAnchor, constant: -30)
        ])
    }
}

// MARK: - Delegate
extension BreastFeedingController: BreastFeedingDelegate {
    func updateTotalLabel(with texte: String) {
        totalTimeBreastLabel.text = "Temps Total : " + texte
    }
}

// MARK: - Picker Delegate
extension BreastFeedingController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        2
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return 61
        } else {
            return 1
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedTime = row
    }

    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        let currentCategory = traitCollection.preferredContentSizeCategory
            if currentCategory.isAccessibilityCategory {
                return 80
            } else {
                return 40
            }
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label = UILabel()
        if let newView = view as? UILabel { label = newView }
        label.textAlignment = .center
        if component == 0 {
            label.text = "\(row)"
            label.setupDynamicTextWith(policeName: "Symbol", size: 25, style: .body)
            label.textAlignment = .right
        } else {
            label.text = " min"
            let currentCategory = traitCollection.preferredContentSizeCategory
            let isAccessibilityCategory = currentCategory.isAccessibilityCategory
            label.setupDynamicTextWith(policeName: "Symbol", size: isAccessibilityCategory ? 14 : 20, style: .body)
            label.textAlignment = .left
        }
        return label
    }
}

// MARK: - Picker Acessibility
extension BreastFeedingController: UIPickerViewAccessibilityDelegate {
    func pickerView(_ pickerView: UIPickerView, accessibilityLabelForComponent component: Int) -> String? {
        if component == 0 {
            return "temps"
        } else {
            return "minutes"
        }
    }

    /// Update the display when the user change the size of the text in the settings
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        reloadpickerForRowHeigt()

        let currentCategory = traitCollection.preferredContentSizeCategory
        let previousCategory = previousTraitCollection?.preferredContentSizeCategory

        guard currentCategory != previousCategory else { return }
        let isAccessibilityCategory = currentCategory.isAccessibilityCategory
        cancelButton.setupDynamicTextWith(policeName: "Symbol", size: isAccessibilityCategory ? 15 : 25, style: .body)
    }

    private func reloadpickerForRowHeigt() {
        rightPicker.delegate = self
        leftPicker.delegate = self
        rightPicker.reloadAllComponents()
        leftPicker.reloadAllComponents()
        view.setNeedsLayout()
    }
}
