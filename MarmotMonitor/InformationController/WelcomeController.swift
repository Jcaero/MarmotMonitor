//
//  babyNameController.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 22/11/2023.
//

import UIKit

final class WelcomeController: ViewForInformationController {
    // MARK: - Properties
    let welcomeTitle: UILabel = {
        let label = UILabel()
        label.text = "Bonjour"
        label.setupDynamicTextWith(policeName: "Symbol", size: 30, style: .body)
        label.textColor = .colorForLabelBlackToBlue
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()

    let subTitle: UILabel = {
        let label = UILabel()
        label.text = "Je vais t'aider à créer ton espace personnalisé"
        label.setupDynamicTextWith(policeName: "Symbol", size: 20, style: .body)
        label.textColor = .label
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()

    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupContraints()

        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }

    // MARK: - function

    private func setupViews() {
        [welcomeTitle, subTitle].forEach {
            stackView.addArrangedSubview($0)
        }
    }

    private func setupContraints() {
        [welcomeTitle, subTitle].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    // MARK: - Action
    @objc private func nextButtonTapped() {
        navigationItem.backButtonDisplayMode = .minimal
        navigationController?.navigationBar.tintColor = .colorForLabelBlackToBlue
        navigationController?.pushViewController(BabyNameController(), animated: true)
    }
}
