//
//  GenderController.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 24/11/2023.
//

import UIKit

final class GenderController: ViewForInformationController {
    
    let genreTitre: UILabel = {
        let label = UILabel()
        label.text = "La petite marmotte est-elle un garçon ou une fille ?"
        label.setupDynamicTextWith(policeName: "Symbol", size: 25, style: .body)
        label.textColor = .colorForLabelBlackToBlue
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
        button.layer.borderColor = UIColor.blue.cgColor
        button.setAccessibility(with: .button, label: "Garçon", hint: "Choisir le sexe masculin")
        return button
    }()

    let girlButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "girl"), for: .normal)
        button.layer.borderColor = UIColor.heavyPink.cgColor
        button.setAccessibility(with: .button, label: "Fille", hint: "Choisir le sexe féminin")
        return button
    }()

    let blanck1 = UIView()
    let blanck2 = UIView()

    // MARK: - Properties

    private var boyButtonHeightConstraint: NSLayoutConstraint?
    private var girlButtonHeightConstraint: NSLayoutConstraint?

    private var viewModel: GenderViewModel!

    // MARK: - cicle life
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = GenderViewModel(delegate: self)

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
        viewModel.buttonTappedWithGender(.boy)
    }

    @objc func girlButtonTapped() {
        viewModel.buttonTappedWithGender(.girl)
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
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 0
    }
}

// MARK: - Accessibility
extension GenderController {
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

        let constante = isAccessibilityCategory ? 100 : 50

        boyButtonHeightConstraint?.constant = CGFloat(constante)
        girlButtonHeightConstraint?.constant = CGFloat(constante)
        view.layoutIfNeeded()
    }
}

extension GenderController {
    // MARK: - Action
    @objc private func nextButtonTapped() {
        viewModel.saveGender()
        navigationController?.pushViewController(ParentNameController(), animated: true)
    }
}

extension GenderController: GenderDelegate {
    func showGender(_ gender: Gender) {
        guard gender != .none else {
            clearGender()
            return
        }

        girlButton.layer.borderWidth = gender == .girl ? 2 : 0
        boyButton.layer.borderWidth = gender == .boy ? 2 : 0

        let color = gender == .girl ? UIColor.heavyPink : .blue
        addShadow(to: pastelArea, with: color)
    }

    private func clearGender() {
        boyButton.layer.borderWidth = 0
        girlButton.layer.borderWidth = 0
        removeShadow(to: pastelArea)
    }
}
