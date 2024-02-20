//
//  GraphtypeViewController.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 07/02/2024.
//

import UIKit

 final class GraphtypeViewController: BackgroundViewController {
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
        label.textAlignment = .left
        label.numberOfLines = 0
        label.text = "Graph Type"
        label.setAccessibility(with: .header, label: "Graph Type", hint: "")
        return label
    }()

    private let subtitleView: UILabel = {
        let label = UILabel()
        label.setupDynamicTextWith(policeName: "Symbol", size: 20, style: .title3)
        label.textColor = .colorForLabelBlackToBlue
        label.textAlignment = .left
        label.numberOfLines = 0
        label.text = "Choisissez le type de graphique"
        return label
    }()

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(GraphTypeTableViewCell.self, forCellReuseIdentifier: GraphTypeTableViewCell.reuseIdentifier)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.layer.cornerRadius = 20
        tableView.setupShadow(radius: 1, opacity: 0.5)
        tableView.clipsToBounds = true
        tableView.isScrollEnabled = false
        return tableView
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

    private let stackViewButton: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.spacing = 30
        return stackView
    }()

    // MARK: - Properties

    private let viewModel = GraphtypeViewModel()
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

        setupButtonAction()
        tableView.delegate = self
        tableView.dataSource = self

        tableView.rowHeight = UITableView.automaticDimension
    }

     override func viewDidLayoutSubviews() {
         saveButton.applyGradient(colors: [UIColor.buttonValidateGradientStarted.cgColor, UIColor.buttonValidateGradientStop.cgColor])
     }

    // MARK: - Setup
    private func setupViews() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(area)
        area.translatesAutoresizingMaskIntoConstraints = false

        [titleView,subtitleView,tableView, stackViewButton].forEach {
            area.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        [cancelButton, saveButton].forEach {
            stackViewButton.addArrangedSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        saveButton.layer.cornerRadius = 10
        cancelButton.layer.cornerRadius = 10
    }

    private func setupContraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor , constant: -10),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            scrollView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -10),
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),

            area.topAnchor.constraint(equalTo: scrollView.topAnchor),
            area.rightAnchor.constraint(equalTo: scrollView.rightAnchor),
            area.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
            area.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20),
            area.widthAnchor.constraint(equalToConstant: (view.frame.width - 20)),
            area.heightAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.heightAnchor),

            titleView.topAnchor.constraint(equalTo: area.topAnchor, constant: 20),
            titleView.leadingAnchor.constraint(equalTo: area.leadingAnchor, constant: 40),
            titleView.trailingAnchor.constraint(equalTo: area.trailingAnchor, constant: -40),
            titleView.heightAnchor.constraint(greaterThanOrEqualToConstant: 60),

            subtitleView.topAnchor.constraint(equalTo: titleView.bottomAnchor),
            subtitleView.leadingAnchor.constraint(equalTo: area.leadingAnchor, constant: 40),
            subtitleView.trailingAnchor.constraint(equalTo: area.trailingAnchor, constant: -40),
            subtitleView.heightAnchor.constraint(greaterThanOrEqualToConstant: 40),

            tableView.topAnchor.constraint(equalTo: subtitleView.bottomAnchor, constant: 40),
            tableView.centerXAnchor.constraint(equalTo: area.centerXAnchor),
            tableView.widthAnchor.constraint(equalTo: area.widthAnchor),
            tableView.heightAnchor.constraint(greaterThanOrEqualTo: view.heightAnchor, multiplier: 0.6),

            stackViewButton.topAnchor.constraint(greaterThanOrEqualTo: tableView.bottomAnchor, constant: 10),
            stackViewButton.centerXAnchor.constraint(equalTo: area.centerXAnchor),
            stackViewButton.bottomAnchor.constraint(lessThanOrEqualTo: area.bottomAnchor, constant: -20),
            stackViewButton.widthAnchor.constraint(equalTo: area.widthAnchor, multiplier: 0.8)
        ])
    }

    // MARK: - Actions
    private func setupButtonAction() {
        saveButton.addTarget(self, action: #selector(saveData), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(holdDown), for: .touchDown)

        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(holdDown), for: .touchDown)
    }

    @objc private func saveData(sender: UIButton) {
        sender.transform = .identity
        sender.layer.shadowOpacity = 0.5
        viewModel.saveGraphType()
        delegate.updateInformation()
        self.dismiss(animated: true, completion: nil)
    }

    @objc func cancel(sender: UIButton) {
        sender.transform = .identity
        sender.layer.shadowOpacity = 0.5
        self.dismiss(animated: true, completion: nil)
    }

    @objc func holdDown(sender: UIButton) {
        sender.transform = CGAffineTransform(scaleX: 0.97, y: 0.97)
        sender.layer.shadowOpacity = 0
    }
}

extension GraphtypeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GraphTypeTableViewCell.reuseIdentifier, for: indexPath) as? GraphTypeTableViewCell else {
            print("erreur de cell")
            return UITableViewCell()
        }
        let (graphName, graphSelection) = viewModel.graphType[indexPath.row]
        cell.configure(with: graphName, isSelected: graphSelection)
        let selected = graphSelection ? "selected" : "not selected"
        cell.accessibilityTraits = .button
        cell.accessibilityValue = "graph type " + graphName + " " + selected
        cell.layer.cornerRadius = 20
        cell.clipsToBounds = true
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.graphTypeSelected(index: indexPath.row)
        tableView.reloadData()
    }

    private func tableView(_ tableView: UITableView, heightForRowInSection section: Int) -> CGFloat {
            return 10
        }

    // MARK: - TraitCollection
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        let currentCategory = traitCollection.preferredContentSizeCategory
        let previousCategory = previousTraitCollection?.preferredContentSizeCategory
        guard currentCategory != previousCategory else { return }
        let isAccessibilityCategory = currentCategory.isAccessibilityCategory
        stackViewButton.axis = isAccessibilityCategory ? .vertical : .horizontal
    }
}
