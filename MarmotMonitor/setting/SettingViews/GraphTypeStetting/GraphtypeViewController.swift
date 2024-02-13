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
            titleAttributes.font = UIFont.preferredFont(forTextStyle: .body)
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
            areaStackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            areaStackView.bottomAnchor.constraint(lessThanOrEqualTo: saveButton.topAnchor, constant: -30),
            saveButton.widthAnchor.constraint(greaterThanOrEqualTo: areaStackView.widthAnchor, multiplier: 0.5)
        ])
    }

    private func fillStackView() {

        for index in 0...2 {
            let view = UIView()
            view.tag = index
            view.backgroundColor = .colorForGradientEnd
            view.layer.cornerRadius = 10

            let graph = GraphView()
            let activities = viewModel.getGraphData()
            switch index {
            case 0:
                graph.setUpGraph(with: (activities, .round))
            case 1:
                graph.setUpGraph(with: (activities, .rod))
            case 2:
                graph.setUpGraph(with: (activities, .ligne))
            default:
                break
            }

            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(buttonTapped))
            view.addGestureRecognizer(tapGesture)

            view.addSubview(graph)
            view.translatesAutoresizingMaskIntoConstraints = false
            graph.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                graph.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
                graph.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
                graph.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
                graph.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10)
            ])

            areaStackView.addArrangedSubview(view)
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

    @objc private func buttonTapped(_ sender: UITapGestureRecognizer) {
        guard let view = sender.view else { return }

        switch view.tag {
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
        view.layer.borderWidth = 6
        view.layer.borderColor = UIColor.red.cgColor
    }

    private func removeAllBorders() {
        for subview in areaStackView.arrangedSubviews {
            subview.layer.borderWidth = 0
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
