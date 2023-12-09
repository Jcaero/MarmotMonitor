//
//  BirthDayController.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 26/11/2023.
//

import UIKit

class BirthDayController: ViewForInformationController, BirthDayDelegate {
    let dateTitre: UILabel = {
        let label = UILabel()
        label.text = "Quel est la date de naissance de la marmotte ?"
        label.setupDynamicTextWith(policeName: "Symbol", size: 25, style: .body)
        label.textColor = .colorForLabelBlackToBrown
        label.textAlignment = .left
        label.numberOfLines = 0
        label.setAccessibility(with: .header, label: "Quel est la date de naissance?", hint: "")
        return label
    }()

    let birthDay: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .inline
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date()
        datePicker.tintColor = .label
        datePicker.backgroundColor = .clear
        datePicker.setAccessibility(with: .selected, label: "", hint: "choisir la date de naissance")
        return datePicker
    }()

    let birthDayTF: UITextField = {
        let textField = UITextField()
        textField.placeholder = "date"
        let font = UIFont(name: "Symbol", size: 20)
        let fontMetrics = UIFontMetrics(forTextStyle: .body)
        textField.font = fontMetrics.scaledFont(for: font!)
        textField.adjustsFontForContentSizeCategory = true
        textField.textColor = .label
        textField.textAlignment = .left
        textField.borderStyle = .roundedRect
        textField.layer.borderColor = UIColor.black.cgColor
        textField.tintColor = .label
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 15
        textField.adjustsFontSizeToFitWidth = true
        textField.textContentType = .name
        textField.backgroundColor = .clear
        textField.setAccessibility(with: .searchField, label: "", hint: "inserer la date de naissance")
        return textField
    }()

    let dateTypeLabel: UILabel = {
        let label = UILabel()
        label.text = "ex: 01/01/2021"
        label.setupDynamicTextWith(policeName: "Symbol", size: 15, style: .body)
        label.textColor = .colorForLabelBlackToBrown
        label.textAlignment = .left
        label.numberOfLines = 0
        label.setAccessibility(with: .header, label: "", hint: "date de naissance au format dd/mm/yyyy")
        return label
    }()

    // MARK: - Properties
    private var viewModel: BirthDayViewModel!
    private var isPickerHidden = false

    // MARK: - Cycle of life
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = BirthDayViewModel(delegate: self)

        setupViews()
        setupContraints()
        setupNextButton()

        updateDisplayAccessibility()

        // MARK: - Keyboard
        birthDayTF.delegate = self
        setupTapGesture()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Functions
    private func setupViews() {
        stackView.addArrangedSubview(dateTitre)
        stackView.addArrangedSubview(birthDay)
    }

    private func setupContraints() {
        roundedImageTopConstraint?.constant = view.frame.height/6
        view.layoutIfNeeded()
    }

    private func setupNextButton() {
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        nextButton.setTitle("Suivant", for: .normal)
        nextButton.setAccessibility(with: .button, label: "Suivant", hint: "Appuyer pour passer à la suite")
    }
}

extension BirthDayController {
    // MARK: - Action
    @objc private func nextButtonTapped() {
        if isPickerHidden {
            viewModel.saveBirthDate(stringDate: birthDayTF.text ?? "")
        } else {
            viewModel.saveBirthDate(date: birthDay.date)
        }
    }

    // MARK: - Navigation
    func pushToNextView() {
        let next = TabBarController() // Assurez-vous que TabBarController est correctement initialisé
        self.navigationController?.setViewControllers([next], animated: true)
    }

    // MARK: - Alert
    func showAlert(title: String, description: String) {
        let alert = UIAlertController(title: title, message: description, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}

extension BirthDayController {
    // MARK: - Keyboard
    /// Check if the keyboard is displayed above textefield  and move the view if necessary
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let textFieldBottomY = birthDayTF.convert(birthDayTF.bounds, to: self.view.window).maxY
                let screenHeight = UIScreen.main.bounds.height
                let keyboardTopY = screenHeight - keyboardSize.height

                if textFieldBottomY > keyboardTopY {
                    self.view.frame.origin.y = -(textFieldBottomY - keyboardTopY) - 20
                }
        }
    }

    /// Return view in the origine place
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }

    @objc func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        birthDayTF.resignFirstResponder()
    }

    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard(_:)))
        view.addGestureRecognizer(tapGesture)
        tapGesture.isEnabled = false
    }
}

extension BirthDayController: UITextFieldDelegate {
    /// remove keyboard when tap to return button
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        nextButtonTapped()
        return true
    }
}

// MARK: - Accessibility
extension BirthDayController {
    /// Update the display when the user change the size of the text in the settings
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        let currentCategory = traitCollection.preferredContentSizeCategory
        let previousCategory = previousTraitCollection?.preferredContentSizeCategory

        guard currentCategory != previousCategory else { return }
        updateDisplayAccessibility()
    }

    /// Update the size of the girl and oy button when the user change the size of the text in the settings
    private func updateDisplayAccessibility() {
        let currentCategory = traitCollection.preferredContentSizeCategory
        let isAccessibilityCategory = currentCategory.isAccessibilityCategory

        if isAccessibilityCategory {
            birthDay.removeFromSuperview()
            isPickerHidden = true
            stackView.addArrangedSubview(dateTypeLabel)
            stackView.addArrangedSubview(birthDayTF)
        } else {
            dateTypeLabel.removeFromSuperview()
            birthDayTF.removeFromSuperview()
            stackView.addArrangedSubview(birthDay)
            isPickerHidden = false
        }

        if let tapGesture = view.gestureRecognizers?.first(where: { $0 is UITapGestureRecognizer }) {
                tapGesture.isEnabled = isPickerHidden
            }
    }
}
