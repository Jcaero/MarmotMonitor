//
//  informationViewController.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 05/02/2024.
//

import UIKit

protocol InformationViewControllerDelegate: AnyObject {
    func updateInformation()
}

class InformationViewController: BackgroundViewController {

    private let titleView: UILabel = {
        let label = UILabel()
        label.setupDynamicBoldTextWith(policeName: "Symbol", size: 34, style: .largeTitle)
        label.textColor = .label
        label.textAlignment = .left
        label.numberOfLines = 0
        label.text = "Information"
        label.setAccessibility(with: .header, label: "Information", hint: "")
        return label
    }()

    private var name: UITextField!
    private var birthDay: UITextField!
    private var parentName: UITextField!
    private var genderSegmentedControl: UISegmentedControl = {
        let items = ["Fille", "Garçon"]
        let control = UISegmentedControl(items: items)
        let font = UIFont.preferredFont(forTextStyle: .body)
        control.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
        control.selectedSegmentTintColor = .duckBlue
        control.selectedSegmentIndex = 0
        return control
    }()

    private let saveButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.plain()
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        configuration.baseBackgroundColor = UIColor.duckBlue
        configuration.background.cornerRadius = 10
        configuration.cornerStyle = .large
        configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { titleAttributes in
            var titleAttributes = titleAttributes
            titleAttributes.font = UIFont.preferredFont(forTextStyle: .body)
            return titleAttributes
        }
        button.configuration = configuration
        button.setTitle("Enregistrer", for: .normal)
        button.setupShadow(radius: 1, opacity: 0.5)
        return button
    }()

    private let cancelButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.tinted()
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 5, bottom: 2, trailing: 5)
        configuration.baseBackgroundColor = .clear
        configuration.background.cornerRadius = 10
        configuration.cornerStyle = .large
        configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { titleAttributes in
            var titleAttributes = titleAttributes
            titleAttributes.font = UIFont.preferredFont(forTextStyle: .body)
            return titleAttributes
        }
        button.configuration = configuration
        button.setTitle("annuler", for: .normal)
        button.setupShadow(radius: 1, opacity: 0.5)
        return button
    }()

    private let topCloud: UIView = {
        let view = UIView()
        view.backgroundColor = .white.withAlphaComponent(0.5)
        return view
    }()

    // MARK: - Properties
    private var viewModel: InformationViewModel!
    private weak var delegate: InformationViewControllerDelegate!

    private var segmentedControlHeightConstraint: NSLayoutConstraint!

    // MARK: - CYCLE LIFE
    init(delegate: InformationViewControllerDelegate) {
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = InformationViewModel(delegate: self)

        view.backgroundColor = .white
        setupUserInfo()

        setupViews()
        setupContraints()

        setupTapGesture()

        setupButtonAction()

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        name.underlined(color: .duckBlue)
        birthDay.underlined(color: .duckBlue)
        parentName.underlined(color: .duckBlue)
        saveButton.applyGradient(colors: [UIColor.duckBlue.cgColor, UIColor.lightBlue.cgColor])

        topCloud.layer.cornerRadius = topCloud.frame.height / 2

        let font = UIFont.preferredFont(forTextStyle: .body)
        genderSegmentedControl.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
        genderSegmentedControl.apportionsSegmentWidthsByContent = true
        adjustSegmentedControlHeightWithAutoLayout(control: genderSegmentedControl)
    }

    // MARK: - Setups
    private func setupUserInfo() {
        viewModel.getUserInformation()
        name = createTextField()
        name.placeholder = viewModel.babyName
        birthDay = createTextField()
        birthDay.placeholder = viewModel.birthDay
        birthDay.keyboardType = .numberPad
        birthDay.addTarget(self, action: #selector(textFieldEditingDidChange), for: UIControl.Event.editingChanged)
        parentName = createTextField()
        parentName.placeholder = viewModel.parentName

        switch viewModel.gender {
        case "Garçon":
            genderSegmentedControl.selectedSegmentIndex = 1
        default:
            genderSegmentedControl.selectedSegmentIndex = 0
        }
    }
    private func setupViews() {
        [topCloud,titleView, cancelButton, saveButton, name, birthDay, parentName, genderSegmentedControl].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    private func setupContraints() {

        segmentedControlHeightConstraint = genderSegmentedControl.heightAnchor.constraint(equalToConstant: 40)
        NSLayoutConstraint.activate([
            topCloud.centerYAnchor.constraint(equalTo: view.topAnchor),
            topCloud.centerXAnchor.constraint(equalTo: view.trailingAnchor),
            topCloud.widthAnchor.constraint(equalTo: topCloud.heightAnchor),
            topCloud.heightAnchor.constraint(equalTo: view.widthAnchor),

            titleView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: view.frame.height * 0.12),
            titleView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            name.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 40),
            name.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            name.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),

            birthDay.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 20),
            birthDay.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            birthDay.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),

            parentName.topAnchor.constraint(equalTo: birthDay.bottomAnchor, constant: 20),
            parentName.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            parentName.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),

            genderSegmentedControl.topAnchor.constraint(equalTo: parentName.bottomAnchor, constant: 20),
            genderSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            genderSegmentedControl.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            segmentedControlHeightConstraint!,

            saveButton.topAnchor.constraint(equalTo: genderSegmentedControl.bottomAnchor, constant: 50),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),

            cancelButton.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 10),
            cancelButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cancelButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7)
        ])
    }

    // MARK: - Actions
    private func setupButtonAction() {
        cancelButton.addTarget(self, action: #selector(closeView), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(holdDown), for: .touchDown)

        saveButton.addTarget(self, action: #selector(saveData), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(holdDown), for: .touchDown)
    }

    @objc private func closeView(sender: UIButton) {
            sender.transform = .identity
            sender.layer.shadowOpacity = 0.5
            self.dismiss(animated: true, completion: nil)
    }

    @objc private func saveData(sender: UIButton) {
            sender.transform = .identity
            sender.layer.shadowOpacity = 0.5
        let gender = genderSegmentedControl.selectedSegmentIndex == 0 ? "Fille" : "Garçon"
        viewModel.saveUserInformation(babyName: name.text, parentName: parentName.text, birthDay: birthDay.text, gender: gender)
        delegate.updateInformation()
        self.dismiss(animated: true, completion: nil)
    }

    @objc func holdDown(sender: UIButton) {
        sender.transform = CGAffineTransform(scaleX: 0.97, y: 0.97)
        sender.layer.shadowOpacity = 0
    }
}

extension InformationViewController {
    private func createTextField() -> UITextField {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(
            string: "0",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray]
        )
        let font = UIFont(name: "Symbol", size: 20)
        let fontMetrics = UIFontMetrics(forTextStyle: .body)
        textField.font = fontMetrics.scaledFont(for: font!)
        textField.textColor = .label
        textField.textAlignment = .left
        textField.keyboardType = .default
        textField.backgroundColor = .clear
        textField.tintColor = .label
        textField.adjustsFontSizeToFitWidth = true
        textField.adjustsFontForContentSizeCategory = true
        textField.delegate = self
        return textField
    }

    @objc private func textFieldEditingDidChange(_ textField: UITextField) {
        guard let text = textField.text else { return }
        if text.count == 2 || text.count == 5 {
            textField.text = text + "/"
        }
    }

}

extension InformationViewController: InformationViewModelDelegate {
    func showAlert(title: String, description: String) {
        showSimpleAlerte(with: title, message: description)
    }
}

//// MARK: - Accessibility
extension InformationViewController {
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        let currentCategory = traitCollection.preferredContentSizeCategory
        let previousCategory = previousTraitCollection?.preferredContentSizeCategory

        guard currentCategory != previousCategory else { return }
        name.sizeToFit()
//        setupAccessibility()
    }

    func adjustSegmentedControlHeightWithAutoLayout(control: UISegmentedControl) {
        let font = UIFont.preferredFont(forTextStyle: .body)
        let testLabel = UILabel()
        testLabel.font = font
        testLabel.text = "Test"
        testLabel.sizeToFit()
        let newHeight = testLabel.frame.size.height + 16 // Ajouter une marge interne

        // Ajuster la contrainte de hauteur
        segmentedControlHeightConstraint.constant = newHeight
    }
}

//    private func setupAccessibility() {
//        let isAccessibilityCategory = traitCollection.preferredContentSizeCategory.isAccessibilityCategory
//        switch isAccessibilityCategory {
//        case true:
//            imageWidthConstraint?.isActive = false
//            imageWidthNilConstraint?.isActive = true
//
//            areaRatioContraint?.isActive = false
//            areaTopContraint?.isActive = true
//
//            buttonStackView.axis = .vertical
//        case false:
//
//        }
//    }
//}

// MARk: - Keyboard
extension InformationViewController: UITextFieldDelegate {
    /// Check if the keyboard is displayed above textefield  and move the view if necessary
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let textFieldBottomY = genderSegmentedControl.convert(genderSegmentedControl.bounds, to: self.view.window).maxY
            let screenHeight = UIScreen.main.bounds.height
            let keyboardTopY = screenHeight - keyboardSize.height

            if textFieldBottomY > keyboardTopY {
                self.view.frame.origin.y = -(textFieldBottomY - keyboardTopY) - 40
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
        name.resignFirstResponder()
        birthDay.resignFirstResponder()
        parentName.resignFirstResponder()
    }

    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard(_:)))
        view.addGestureRecognizer(tapGesture)
    }

    /// remove keyboard when tap to return button
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
