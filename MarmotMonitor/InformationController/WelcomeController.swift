//
//  babyNameController.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 22/11/2023.
//

import UIKit
/// WelcomeController
/// This class is the first controller of the application
/// It is used to welcome the user and to explain the purpose of the application

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
        nextButton.addTarget(self, action: #selector(holdDown), for: .touchDown)
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
    @objc private func nextButtonTapped(_ sender: UIButton) {
        sender.transform = .identity
        sender.layer.shadowOpacity = 0.5
        navigationItem.backButtonDisplayMode = .minimal
        navigationController?.navigationBar.tintColor = .colorForLabelBlackToBlue
        navigationController?.pushViewController(BabyNameController(), animated: true)
    }

    @objc func holdDown(sender: UIButton) {
        sender.transform = CGAffineTransform(scaleX: 0.97, y: 0.97)
        sender.layer.shadowOpacity = 0
    }
}
