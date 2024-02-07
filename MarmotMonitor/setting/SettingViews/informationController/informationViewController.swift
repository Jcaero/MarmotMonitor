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

class InformationViewController: UIViewController {

    private let area: UIView = {
        let view = UIView()
        view.backgroundColor = .colorForGraphBackground
        view.layer.cornerRadius = 20
        view.setupShadow(radius: 1, opacity: 0.5)
        return view
    }()

    private let buttonStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 10
        view.distribution = .equalCentering
        return view
    }()

    private let informationStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fillEqually
        view.spacing = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private var name: UITextField!
    private var birthDay: UITextField!
    private var parentName: UITextField!
    private var genderSegmentedControl: UISegmentedControl = {
        let items = ["Fille", "Garçon"]
        let control = UISegmentedControl(items: items)
        control.selectedSegmentTintColor = .colorForDuckBlueToWhite
        control.selectedSegmentIndex = 0
        return control
    }()

    private let babyImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "nameMarmotte")
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        return imageView
    }()

    private let saveButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.filled()
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 5, bottom: 2, trailing: 5)
        configuration.baseBackgroundColor = UIColor.colorForDuckBlueToWhite
        configuration.background.cornerRadius = 10
        configuration.cornerStyle = .large
        configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { titleAttributes in
            var titleAttributes = titleAttributes
            titleAttributes.font = UIFont.preferredFont(forTextStyle: .footnote)
            return titleAttributes
        }
        button.configuration = configuration
        button.setTitle("Enegistrer", for: .normal)
        button.setupShadow(radius: 1, opacity: 0.5)
        return button
    }()

    private let cancelButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.filled()
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 5, bottom: 2, trailing: 5)
        configuration.baseBackgroundColor = UIColor.colorForDuckBlueToWhite
        configuration.background.cornerRadius = 10
        configuration.cornerStyle = .large
        configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { titleAttributes in
            var titleAttributes = titleAttributes
            titleAttributes.font = UIFont.preferredFont(forTextStyle: .footnote)
            return titleAttributes
        }
        button.configuration = configuration
        button.setTitle("annuler", for: .normal)
        button.setupShadow(radius: 1, opacity: 0.5)
        return button
    }()

    // MARK: - Properties
    private var viewModel: InformationViewModel!
    private weak var delegate: InformationViewControllerDelegate!

    // MARK: - Constraints for accessibility
    private var imageWidthConstraint: NSLayoutConstraint?
    private var imageWidthNilConstraint: NSLayoutConstraint?

    private var areaRatioContraint: NSLayoutConstraint?
    private var areaTopContraint: NSLayoutConstraint?

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

        view.backgroundColor = .clear
        setupUserInfo()
        setupBlurEffect()

        setupViews()
        setupContraints()
        setupAccessibility()

        setupTapGesture()
        setupTextFieldDelegate()

        setupButtonAction()

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Effects
    private func setupBlurEffect() {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.prominent)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
    }

    // MARK: - Setups
    private func setupUserInfo() {
        viewModel.getUserInformation()

        name = createTextField()
        name.placeholder = viewModel.babyName
        birthDay = createTextField()
        birthDay.placeholder = viewModel.birthDay
        parentName = createTextField()
        parentName.placeholder = viewModel.parentName

        switch viewModel.gender {
        case "Fille":
            genderSegmentedControl.selectedSegmentIndex = 0
        case "Garçon":
            genderSegmentedControl.selectedSegmentIndex = 1
        default:
            genderSegmentedControl.selectedSegmentIndex = 0
        }
    }
    private func setupViews() {
        view.addSubview(area)
        area.translatesAutoresizingMaskIntoConstraints = false

        [babyImage, informationStackView, buttonStackView ].forEach {
            area.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        [name, birthDay, parentName, genderSegmentedControl].forEach {
            informationStackView.addArrangedSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        // Add the buttons to the stackView
        let empty = UIView()
        let empty2 = UIView()
        let empty3 = UIView()
        [empty, cancelButton, empty3, saveButton, empty2].forEach {
            buttonStackView.addArrangedSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        view.addSubview(buttonStackView)
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupContraints() {
        imageWidthConstraint = babyImage.widthAnchor.constraint(equalTo: area.widthAnchor, multiplier: 0.2)
        imageWidthNilConstraint = babyImage.widthAnchor.constraint(equalToConstant: 0)

        areaTopContraint = area.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10)
        areaRatioContraint = area.heightAnchor.constraint(equalTo: area.widthAnchor, multiplier: 0.5)

        NSLayoutConstraint.activate([
            area.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            area.bottomAnchor.constraint(equalTo: view.centerYAnchor),
            area.widthAnchor.constraint(equalToConstant: view.frame.width * 0.85),
            areaRatioContraint!,

            babyImage.centerYAnchor.constraint(equalTo: area.centerYAnchor),
            babyImage.leftAnchor.constraint(equalTo: area.leftAnchor, constant: 10),
            babyImage.heightAnchor.constraint(equalTo: babyImage.widthAnchor),
            imageWidthConstraint!,

            informationStackView.topAnchor.constraint(equalTo: area.topAnchor, constant: 10),
            informationStackView.leftAnchor.constraint(equalTo: babyImage.rightAnchor, constant: 10),
            informationStackView.rightAnchor.constraint(equalTo: area.rightAnchor, constant: -10),
            informationStackView.bottomAnchor.constraint(equalTo: area.bottomAnchor, constant: -10),

            buttonStackView.topAnchor.constraint(equalTo: area.bottomAnchor, constant: 10),
            buttonStackView.leftAnchor.constraint(equalTo: area.leftAnchor, constant: 10),
            buttonStackView.rightAnchor.constraint(equalTo: area.rightAnchor, constant: -10)
        ])
    }

    func setupTitle(with name: String, birthDay: String, parent: String) {
        self.name.text = name
        self.birthDay.text = birthDay
        self.parentName.text = parent
    }

    private func setupTextFieldDelegate() {
        name.delegate = self
        birthDay.delegate = self
        parentName.delegate = self
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
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray3]
        )
        let font = UIFont(name: "Symbol", size: 20)
        let fontMetrics = UIFontMetrics(forTextStyle: .body)
        textField.font = fontMetrics.scaledFont(for: font!)
        textField.textColor = .label
        textField.textAlignment = .left
        textField.borderStyle = .roundedRect
        textField.layer.borderColor = UIColor.duckBlue.cgColor
        textField.layer.borderWidth = 2
        textField.layer.cornerRadius = 10
        textField.keyboardType = .default
        textField.backgroundColor = .clear
        textField.tintColor = .systemGray6
        textField.adjustsFontSizeToFitWidth = true
        return textField
    }
}

extension InformationViewController: InformationViewModelDelegate {
    func showAlert(title: String, description: String) {
        showSimpleAlerte(with: title, message: description)
    }
}

// MARK: - Accessibility
extension InformationViewController {
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        let currentCategory = traitCollection.preferredContentSizeCategory
        let previousCategory = previousTraitCollection?.preferredContentSizeCategory

        guard currentCategory != previousCategory else { return }

        setupAccessibility()
    }

    private func setupAccessibility() {
        let isAccessibilityCategory = traitCollection.preferredContentSizeCategory.isAccessibilityCategory
        switch isAccessibilityCategory {
        case true:
            imageWidthConstraint?.isActive = false
            imageWidthNilConstraint?.isActive = true

            areaRatioContraint?.isActive = false
            areaTopContraint?.isActive = true

            buttonStackView.axis = .vertical
        case false:
            imageWidthNilConstraint?.isActive = false
            imageWidthConstraint?.isActive = true

            areaTopContraint?.isActive = false
            areaRatioContraint?.isActive = true
            buttonStackView.axis = .horizontal
        }
    }
}

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
