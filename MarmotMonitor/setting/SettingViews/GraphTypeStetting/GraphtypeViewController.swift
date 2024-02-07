//
//  GraphtypeViewController.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 07/02/2024.
//

import UIKit

class GraphtypeViewController: BackgroundViewController {

    private let titleView: UILabel = {
        let label = UILabel()
        label.setupDynamicBoldTextWith(policeName: "Symbol", size: 30, style: .title1)
        label.textColor = .colorForLabelBlackToBlue
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()

    private let areaStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 20
        view.distribution = .fillEqually
        return view
    }()

    private let saveButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.filled()
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 5, bottom: 10, trailing: 5)
        configuration.baseBackgroundColor = UIColor.duckBlue
        configuration.background.cornerRadius = 10
        configuration.cornerStyle = .large
        configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { titleAttributes in
            var titleAttributes = titleAttributes
            titleAttributes.font = UIFont.preferredFont(forTextStyle: .footnote)
            return titleAttributes
        }
        button.configuration = configuration
        button.setTitle("Enregistrer", for: .normal)
        button.setupShadow(radius: 1, opacity: 0.5)
        return button
    }()

    // MARK: - Properties

    let viewModel = GraphtypeViewModel()
    private weak var delegate: InformationViewControllerDelegate!

    // MARK: - Circle Life
    init(delegate: InformationViewControllerDelegate) {
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .colorForGraphBackground
        titleView.text = "Graph Type"

        setupViews()
        setupContraints()
        fillStackView()

        setupButtonAction()
    }

    // MARK: - Setup
    private func setupViews() {
        [titleView, areaStackView, saveButton].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    private func setupContraints() {
        NSLayoutConstraint.activate([
            titleView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            titleView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 40),
            titleView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -40),
            titleView.heightAnchor.constraint(greaterThanOrEqualToConstant: 50),

            saveButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),

            areaStackView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 30),
            areaStackView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            areaStackView.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor, multiplier: 0.8),
            areaStackView.bottomAnchor.constraint(lessThanOrEqualTo: saveButton.topAnchor, constant: -30),
            saveButton.widthAnchor.constraint(greaterThanOrEqualTo: areaStackView.widthAnchor, multiplier: 0.5)
        ])
    }

    private func fillStackView() {
        let graphType = ["graphRound", "graphRod", "graphLigne"]
        for (index, type) in graphType.enumerated() {
            guard let image = UIImage(named: type) else { return }
            let button = createButton(image)
            button.tag = index
            if type == viewModel.getGraphType()?.imageNameSynthese {
                button.layer.borderWidth = 6
                button.layer.borderColor = UIColor.red.cgColor
            }
            areaStackView.addArrangedSubview(button)
        }
    }

    private func createButton(_ image: UIImage) -> UIButton {
        let button = UIButton()
        button.backgroundColor = .duckBlue
        button.setBackgroundImage(image, for: .normal)
        button.layer.cornerRadius = 20
        button.heightAnchor.constraint(equalTo: button.widthAnchor, multiplier: 0.5).isActive = true
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }

    @objc private func buttonTapped(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            viewModel.setGraphType(graphType: .round)
        case 1:
            viewModel.setGraphType(graphType: .rod)
        case 2:
            viewModel.setGraphType(graphType: .ligne)
        default:
            break
        }

        removeAllBorders()
        sender.layer.borderWidth = 6
        sender.layer.borderColor = UIColor.red.cgColor
    }

    private func removeAllBorders() {
        for subview in areaStackView.arrangedSubviews {
            guard let button = subview as? UIButton else { return }
            button.layer.borderWidth = 0
        }
    }

    // MARK: - Actions
    private func setupButtonAction() {
        saveButton.addTarget(self, action: #selector(saveData), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(holdDown), for: .touchDown)
    }

    @objc private func saveData(sender: UIButton) {
            sender.transform = .identity
            sender.layer.shadowOpacity = 0.5
        delegate.updateInformation()
        self.dismiss(animated: true, completion: nil)
    }

    @objc func holdDown(sender: UIButton) {
        sender.transform = CGAffineTransform(scaleX: 0.97, y: 0.97)
        sender.layer.shadowOpacity = 0
    }
}
