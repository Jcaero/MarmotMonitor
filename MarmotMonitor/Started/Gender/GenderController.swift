//
//  GenderController.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 24/11/2023.
//

import UIKit

final class GenderController: StandardStartedViewController {
    let genreTitre: UILabel = {
        let label = UILabel()
        label.text = "La petite marmotte est-elle un garçon ou une fille ?"
        label.setupDynamicTextWith(policeName: "Symbol", size: 25, style: .body)
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 0
        label.setAccessibility(with: .header, label: "La petite marmotte est-elle un garçon ou une fille ?", hint: "")
        return label
    }()

    let genderStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .center
        stackView.distribution = .equalCentering
        return stackView
    }()

    let boyButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "boy"), for: .normal)
        button.setAccessibility(with: .button, label: "Garçon", hint: "Choisir le sexe masculin")
        return button
    }()

    let girlButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "girl"), for: .normal)
        button.setAccessibility(with: .button, label: "Fille", hint: "Choisir le sexe féminin")
        return button
    }()

    let blanck1 = UIView()
    let blanck2 = UIView()

    // MARK: - Properties

    private var boyButtonHeightConstraint: NSLayoutConstraint?
    private var girlButtonHeightConstraint: NSLayoutConstraint?

    private let viewModel = GenderViewModel()

    // MARK: - cicle life
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupContraints()
        setupGenderButton()
        setupNextButton()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        boyButton.layer.cornerRadius = boyButton.frame.width / 2
        girlButton.layer.cornerRadius = boyButton.frame.width / 2
    }

    private func setupView() {
        [blanck1, boyButton, girlButton, blanck2].forEach {
            genderStackView.addArrangedSubview($0)
        }

        [genreTitre, genderStackView].forEach {
            stackView.addArrangedSubview($0)
        }
    }

    private func setupContraints() {
        [blanck1, boyButton, girlButton, blanck2, genreTitre, genderStackView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        boyButtonHeightConstraint = boyButton.heightAnchor.constraint(equalToConstant: 70)
        girlButtonHeightConstraint = girlButton.heightAnchor.constraint(equalToConstant: 70)

        NSLayoutConstraint.activate([
            boyButtonHeightConstraint!,
            boyButton.widthAnchor.constraint(equalTo: boyButton.heightAnchor),
            girlButtonHeightConstraint!,
            girlButton.widthAnchor.constraint(equalTo: girlButton.heightAnchor)
        ])
    }

    private func setupGenderButton() {
        girlButton.addTarget(self, action: #selector(girlButtonTapped), for: .touchUpInside)
        boyButton.addTarget(self, action: #selector(boyButtonTapped), for: .touchUpInside)
    }

    private func setupNextButton() {
        nextButton.setTitle("Suivant", for: .normal)
        nextButton.setAccessibility(with: .button, label: "Suivant", hint: "Passer à l'étape suivante")
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }

    // MARK: - function
    @objc func boyButtonTapped() {
        if boyButton.layer.borderWidth == 2 {
            boyButton.layer.borderWidth = 0
            removeShadow(to: pastelArea)
            viewModel.clearGender()
        } else {
            boyButton.layer.borderWidth = 2
            girlButton.layer.borderWidth = 0
            boyButton.layer.borderColor = UIColor.blue.cgColor
            addShadow(to: pastelArea, with: .blue)
            viewModel.setBoyGender()
        }
    }

    @objc func girlButtonTapped() {
        if girlButton.layer.borderWidth == 2 {
            girlButton.layer.borderWidth = 0
            removeShadow(to: pastelArea)
            viewModel.clearGender()
        } else {
            girlButton.layer.borderWidth = 2
            boyButton.layer.borderWidth = 0
            girlButton.layer.borderColor = UIColor.heavyPink.cgColor
            addShadow(to: pastelArea, with: .heavyPink)
            viewModel.setGirlGender()
        }
    }

    private func addShadow(to view: UIView, with color: UIColor) {
        view.layer.masksToBounds = false
        view.layer.shadowColor = color.cgColor
        view.layer.shadowOpacity = 0.7
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 20
    }

    private func removeShadow(to view: UIView) {
        view.layer.shadowColor = nil
        view.layer.shadowOpacity = 0
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowRadius = 0
    }
}

// MARK: - Accessibility
extension GenderController {
    /// Update the display when the user change the size of the text in the settings
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        let currentCategory = traitCollection.preferredContentSizeCategory
        let previousCategory = previousTraitCollection?.preferredContentSizeCategory

        guard currentCategory != previousCategory else { return }
        updateDisplayAccessibility()
    }

    /// Update the size of the girl and oy button when the user change the size of the text in the settings
    private func updateDisplayAccessibility() {
        let currentCategory = traitCollection.preferredContentSizeCategory
        let isAccessibilityCategory = currentCategory.isAccessibilityCategory

        let constant = isAccessibilityCategory ? 100 : 50
        boyButtonHeightConstraint?.constant = CGFloat(constant)
        girlButtonHeightConstraint?.constant = CGFloat(constant)

         view.layoutIfNeeded()
    }
}

extension GenderController {
    // MARK: - Action
    @objc private func nextButtonTapped() {
        viewModel.saveGender()
        navigationItem.backButtonDisplayMode = .minimal
        navigationController?.navigationBar.tintColor = .black
        navigationController?.pushViewController(ParentNameController(), animated: true)
    }
}
