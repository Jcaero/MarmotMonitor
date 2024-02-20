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

final class InformationViewController: BackgroundViewController {

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .clear
        scrollView.layer.cornerRadius = 20
        return scrollView
    }()

    private let area: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()

    private let titleView: UILabel = {
        let label = UILabel()
        label.setupDynamicBoldTextWith(policeName: "Symbol", size: 34, style: .largeTitle)
        label.textColor = .label
        label.backgroundColor = .clearToEgiptienBlue
        label.layer.cornerRadius = 20
        label.clipsToBounds = true
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
        let font = UIFont.preferredFont(forTextStyle: .caption1)
        control.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
        control.selectedSegmentTintColor = .duckBlue
        control.selectedSegmentIndex = 0
        return control
    }()

    private let saveButton: UIButton = {
        let button = UIButton()
        button.createActionButton(type: .valider)
        return button
    }()

    private let cancelButton: UIButton = {
        let button = UIButton()
        button.createActionButton(type: .retour)
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
    private var topTitleContraint: NSLayoutConstraint!
    private var segmentedSize: UIFont.TextStyle = .body

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
        viewModel = InformationViewModel()

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
        addUnderlined(to: [name, birthDay, parentName])

        saveButton.applyGradient(colors: [UIColor.buttonValidateGradientStarted.cgColor, UIColor.buttonValidateGradientStop.cgColor])

        topCloud.layer.cornerRadius = topCloud.frame.height / 2

        setSegmentedSize()
    }

    private func addUnderlined(to textFields: [UITextField]) {
        textFields.forEach { $0.underlined(color: .duckBlue) }
    }

    private func setSegmentedSize() {
        let font = UIFont.preferredFont(forTextStyle: segmentedSize)
        genderSegmentedControl.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
        genderSegmentedControl.apportionsSegmentWidthsByContent = true
        adjustSegmentedControlHeightWithAutoLayout(control: genderSegmentedControl)
    }

    // MARK: - Setups
    private func setupUserInfo() {
        viewModel.getUserInformation()
        name = createTextField()
        name.accessibilityHint = "Nom de l'enfant"
        name.placeholder = viewModel.babyName

        birthDay = createTextField()
        birthDay.placeholder = viewModel.birthDay
        birthDay.keyboardType = .numberPad
        birthDay.addTarget(self, action: #selector(textFieldEditingDidChange), for: UIControl.Event.editingChanged)
        birthDay.accessibilityHint = "Date de naissance"

        parentName = createTextField()
        parentName.placeholder = viewModel.parentName
        parentName.accessibilityHint = "Nom du parent"

        let isBoy = viewModel.gender == "Garçon"
        genderSegmentedControl.selectedSegmentIndex = isBoy ? 1 : 0
        genderSegmentedControl.accessibilityHint = "Sélectionner le genre"
    }

    private func setupViews() {
        [topCloud, scrollView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }

        area.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(area)

        [titleView, cancelButton, saveButton, name, birthDay, parentName, genderSegmentedControl].forEach {
            area.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    private func setupContraints() {

        segmentedControlHeightConstraint = genderSegmentedControl.heightAnchor.constraint(equalToConstant: 40)
        topTitleContraint = titleView.topAnchor.constraint(equalTo: area.topAnchor, constant: view.frame.height * 0.2)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor , constant: -20),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            scrollView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            scrollView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),

            area.topAnchor.constraint(equalTo: scrollView.topAnchor),
            area.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: -30),
            area.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 30),
            area.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20),
            area.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -60),
            area.heightAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.heightAnchor),

            topCloud.centerYAnchor.constraint(equalTo: view.topAnchor),
            topCloud.centerXAnchor.constraint(equalTo: view.rightAnchor),
            topCloud.widthAnchor.constraint(equalTo: topCloud.heightAnchor),
            topCloud.heightAnchor.constraint(equalTo: view.widthAnchor),

            topTitleContraint!,
            titleView.leadingAnchor.constraint(equalTo: area.leadingAnchor),
            titleView.trailingAnchor.constraint(lessThanOrEqualTo: area.trailingAnchor),

            name.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 40),
            name.centerXAnchor.constraint(equalTo: area.centerXAnchor),
            name.widthAnchor.constraint(equalTo: area.widthAnchor),

            birthDay.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 20),
            birthDay.centerXAnchor.constraint(equalTo: area.centerXAnchor),
            birthDay.widthAnchor.constraint(equalTo: area.widthAnchor),

            parentName.topAnchor.constraint(equalTo: birthDay.bottomAnchor, constant: 20),
            parentName.centerXAnchor.constraint(equalTo: area.centerXAnchor),
            parentName.widthAnchor.constraint(equalTo: area.widthAnchor),

            genderSegmentedControl.topAnchor.constraint(equalTo: parentName.bottomAnchor, constant: 20),
            genderSegmentedControl.centerXAnchor.constraint(equalTo: area.centerXAnchor),
            genderSegmentedControl.widthAnchor.constraint(equalTo: area.widthAnchor),
            segmentedControlHeightConstraint!,

            saveButton.topAnchor.constraint(greaterThanOrEqualTo: genderSegmentedControl.bottomAnchor, constant: 20),
            saveButton.centerXAnchor.constraint(equalTo: area.centerXAnchor),
            saveButton.widthAnchor.constraint(equalTo: area.widthAnchor),

            cancelButton.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 10),
            cancelButton.centerXAnchor.constraint(equalTo: area.centerXAnchor),
            cancelButton.widthAnchor.constraint(equalTo: area.widthAnchor),
            cancelButton.bottomAnchor.constraint(lessThanOrEqualTo: area.bottomAnchor, constant: -20)
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

        let gender = genderSegmentedControl.selectedSegmentIndex == 0 ? Gender.girl : Gender.boy
        let person = Person(name: name.text, gender: gender, parentName: parentName.text, birthDay:birthDay.text)

        viewModel.saveUserInformation(person: person) { [weak self] result in
            switch result {
            case .success:
                self?.delegate.updateInformation()
                self?.dismiss(animated: true, completion: nil)
            case .failure(let error):
                self?.showAlert(title: "Erreur", description: error.description)
            }
        }
    }

    @objc func holdDown(sender: UIButton) {
        sender.transform = CGAffineTransform(scaleX: 0.97, y: 0.97)
        sender.layer.shadowOpacity = 0
    }
}

extension InformationViewController {
   /// Create a textfield with the right configuration
    /// - Returns: a textfield
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

    /// Insert automatically the "/" in the date textfield
    /// - Parameter textField: the textfield to edit
    @objc private func textFieldEditingDidChange(_ textField: UITextField) {
        guard let text = textField.text else { return }
        if text.count == 2 || text.count == 5 {
            textField.text = text + "/"
        }
    }

    // MARK: - Alert
    func showAlert(title: String, description: String) {
        showSimpleAlerte(with: title, message: description)
    }

// MARK: - Accessibility
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        let currentCategory = traitCollection.preferredContentSizeCategory
        let previousCategory = previousTraitCollection?.preferredContentSizeCategory

        guard currentCategory != previousCategory else { return }
        let isAccessibilityCategory = traitCollection.preferredContentSizeCategory.isAccessibilityCategory
        topTitleContraint.constant = isAccessibilityCategory ? 40 : view.frame.height * 0.2
        segmentedSize = isAccessibilityCategory ? .caption2 : .body
        name.sizeToFit()
    }

    /// Adjust the segmented control height with auto layout
    /// - Parameter control: the segmented control to adjust
    /// - Note: The segmented control height is adjusted with the font size
    func adjustSegmentedControlHeightWithAutoLayout(control: UISegmentedControl) {
        let font = UIFont.preferredFont(forTextStyle: .body)
        let testLabel = UILabel()
        testLabel.font = font
        testLabel.text = "Test"
        testLabel.sizeToFit()
        let newHeight = testLabel.frame.size.height + 16

        segmentedControlHeightConstraint.constant = newHeight
    }
}

// MARK: - Keyboard
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
