//
//  babyNameController.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 22/11/2023.
//

import UIKit

final class BabyNameController: StandardStartedViewController {
    // MARK: - Properties
    let babyNameTitre: UILabel = {
        let label = UILabel()
        label.text = "Quel est le nom de la petite marmotte ?"
        label.setupDynamicTextWith(policeName: "Symbol", size: 25, style: .body)
        label.textColor = .colorForLabelBlackToBrown
        label.textAlignment = .left
        label.numberOfLines = 0
        label.setAccessibility(with: .header, label: "Quel est le nom de la petite marmotte ?", hint: "")
        return label
    }()

    let babyName: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Nom du bébé"
        let font = UIFont(name: "Symbol", size: 20)
        let fontMetrics = UIFontMetrics(forTextStyle: .body)
        textField.font = fontMetrics.scaledFont(for: font!)
        textField.adjustsFontForContentSizeCategory = true
        textField.textColor = .label
        textField.textAlignment = .left
        textField.borderStyle = .roundedRect
        textField.layer.borderColor = UIColor.label.cgColor
        textField.tintColor = .label
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 15
        textField.adjustsFontSizeToFitWidth = true
        textField.textContentType = .name
        textField.backgroundColor = .colorForPastelArea
        textField.setAccessibility(with: .keyboardKey, label: "", hint: "inserer le nom de Bébé")
        return textField
    }()

    // MARK: - Propriete
    private let viewModel = BabyNameViewModel()

    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupContraints()

        setupNextButton()
        initNavigationBar()

        setupTapGesture()
        babyName.delegate = self

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    // MARK: - function

    private func setupViews() {

        [babyNameTitre, babyName].forEach {
            stackView.addArrangedSubview($0)
        }
    }

    private func setupContraints() {
        [babyName, babyNameTitre].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            babyName.heightAnchor.constraint(greaterThanOrEqualToConstant: 50)
        ])
    }

    private func setupNextButton() {
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        nextButton.setTitle("Suivant", for: .normal)
        nextButton.setAccessibility(with: .button, label: "Suivant", hint: "Appuyer pour passer à la suite")
        nextButton.isEnabled = false
        nextButton.accessibilityTraits.insert(.notEnabled)
        nextButton.setTitleColor(.gray, for: .normal)
    }

    // MARK: - Keyboard
    /// Check if the keyboard is displayed above textefield  and move the view if necessary
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let textFieldBottomY = babyName.convert(babyName.bounds, to: self.view.window).maxY
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
        babyName.resignFirstResponder()
    }

    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard(_:)))
        view.addGestureRecognizer(tapGesture)
    }
}

extension BabyNameController: UITextFieldDelegate {
    /// remove keyboard when tap to return button
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidChangeSelection(_ textField: UITextField) {
        if let text = textField.text, text.count >= 2 {
            nextButton.isEnabled = true
            nextButton.accessibilityTraits.remove(.notEnabled)
            nextButton.setTitleColor(.colorForLabelNextButtonDefault, for: .normal)
        } else {
            nextButton.isEnabled = false
            nextButton.accessibilityTraits.insert(.notEnabled)
            nextButton.setTitleColor(.gray, for: .normal)
        }
    }
}

extension BabyNameController {
    // MARK: - Action
    @objc private func nextButtonTapped() {
        viewModel.saveBabyName(name: babyName.text ?? "")
//        navigationItem.backButtonDisplayMode = .minimal
//        navigationController?.navigationBar.tintColor = .colorForLabelBlackToBrown
        navigationController?.pushViewController(GenderController(), animated: true)
    }
}

// MARK: - Accessibility
extension BabyNameController {
    /// Update the display when the user change the size of the text in the settings
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        let currentCategory = traitCollection.preferredContentSizeCategory
        let previousCategory = previousTraitCollection?.preferredContentSizeCategory

        guard currentCategory != previousCategory else { return }
        let isAccessibilityCategory = currentCategory.isAccessibilityCategory
        
        babyName.placeholder = isAccessibilityCategory ? "Nom" : "Nom du bébé"
    }
}
