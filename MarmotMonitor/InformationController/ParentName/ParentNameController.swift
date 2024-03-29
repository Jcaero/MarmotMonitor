//
//  parentNameController.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 25/11/2023.
//

import UIKit

/// ParentNameController
/// This class is used to ask the user the name of parent
/// The user can go to the next step without entered a name
/// The name is saved in the UserDefaultsManager
/// The user can go back to the previous step
final class ParentNameController: ViewForInformationController {
    // MARK: - Properties
    let parentNameTitre: UILabel = {
        let label = UILabel()
        label.text = "Quel est le nom du parent ?"
        label.setupDynamicTextWith(policeName: "Symbol", size: 25, style: .body)
        label.textColor = .colorForLabelBlackToBlue
        label.textAlignment = .left
        label.numberOfLines = 0
        label.setAccessibility(with: .header, label: "Quel est le nom du parent ?", hint: "")
        return label
    }()

    let parentName: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Nom du Parent"
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
        textField.setAccessibility(with: .keyboardKey, label: "", hint: "inserer le nom du parent")
        return textField
    }()

    // MARK: - Properties
    private let userDefaultsManager = UserDefaultsManager()

    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupContraints()
        setupNextButton()

        setupTapGesture()
        parentName.delegate = self

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    // MARK: - function

    private func setupViews() {
        view.backgroundColor = .white

        [parentNameTitre, parentName].forEach {
            stackView.addArrangedSubview($0)
        }
    }

    private func setupContraints() {
        [parentName, parentNameTitre].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            parentName.heightAnchor.constraint(greaterThanOrEqualToConstant: 50)
        ])
    }

    private func setupNextButton() {
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(holdDown), for: .touchDown)
        nextButton.setTitle("Suivant", for: .normal)
        nextButton.setAccessibility(with: .button, label: "Suivant", hint: "Appuyer pour passer à la suite")
    }

    // MARK: - Keyboard
    /// Check if the keyboard is displayed above textefield  and move the view if necessary
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let textFieldBottomY = parentName.convert(parentName.bounds, to: self.view.window).maxY
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

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        parentName.resignFirstResponder()
    }

    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard(_:)))
        view.addGestureRecognizer(tapGesture)
    }
}

extension ParentNameController: UITextFieldDelegate {
    /// remove keyboard when tap to return button
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        goNextController()
        return true
    }

    // MARK: - Action
    @objc private func nextButtonTapped(sender: UIButton) {
        sender.transform = .identity
        sender.layer.shadowOpacity = 0.5
        goNextController()
    }

    @objc func holdDown(sender: UIButton) {
        sender.transform = CGAffineTransform(scaleX: 0.97, y: 0.97)
        sender.layer.shadowOpacity = 0
    }

    private func goNextController() {
        userDefaultsManager.saveParentName(parentName.text)
        navigationController?.pushViewController(BirthDayController(), animated: true)
    }

// MARK: - Accessibility
    /// Update the display when the user change the size of the text in the settings
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        let currentCategory = traitCollection.preferredContentSizeCategory
        let previousCategory = previousTraitCollection?.preferredContentSizeCategory

        guard currentCategory != previousCategory else { return }
        let isAccessibilityCategory = currentCategory.isAccessibilityCategory

        parentName.placeholder = isAccessibilityCategory ? "Nom" : "Nom du Parent"
    }
}
