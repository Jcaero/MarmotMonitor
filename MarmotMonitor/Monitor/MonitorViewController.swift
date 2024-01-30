//
//  MonitorViewController.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 23/01/2024.
//

import UIKit

class MonitorViewController: BackgroundViewController {

    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = .clear
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .singleLine
        tableView.layer.cornerRadius = 20
        tableView.isScrollEnabled = true
        return tableView
    }()

    private let filterStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .equalSpacing
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupContraints()

        setupTableView()
        setupFilterStackView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.updateData()
        tableView.reloadData()
    }

    private var viewModel = MonitorViewModel()

    // MARK: - Setup views
    private func setupViews() {
        view.addSubview(tableView)
        view.addSubview(filterStackView)
    }

    private func setupContraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        filterStackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            filterStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 2),
            filterStackView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -30),
            filterStackView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 30),
            filterStackView.heightAnchor.constraint(greaterThanOrEqualToConstant: 50),

            tableView.topAnchor.constraint(equalTo: filterStackView.bottomAnchor, constant: 20),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MonitorCell.self, forCellReuseIdentifier: MonitorCell.reuseIdentifier)
    }
}

// MARK: - Setup filter
extension MonitorViewController {

    private func setupFilterStackView() {
        [ActivityIconName.sleep.rawValue, ActivityIconName.meal.rawValue, ActivityIconName.diaper.rawValue].enumerated().forEach { (index, iconeName) in
            let button = UIButton()
            var configuration = UIButton.Configuration.filled()
            configuration.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            configuration.title = iconeName.capitalizeFirstLetter()
            configuration.baseForegroundColor = .colorForGradientEnd
            configuration.baseBackgroundColor = UIColor.colorForIcone(imageName: iconeName)
            configuration.background.cornerRadius = 10
            configuration.cornerStyle = .large
            configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { titleAttributes in
                var titleAttributes = titleAttributes
                titleAttributes.font = UIFont.preferredFont(forTextStyle: .body)
                return titleAttributes
            }
            button.configuration = configuration
            setupShadowOf(button, radius: 1, opacity: 0.5)
            button.titleLabel?.adjustsFontForContentSizeCategory = true
            button.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
            button.addTarget(self, action: #selector(holdDown), for: .touchDown)

            button.setAccessibility(with: .button, label: iconeName, hint: "Selectionner pour filtrer les activités")

            button.tag = index
            filterStackView.addArrangedSubview(button)
        }
    }

    @objc private func filterButtonTapped(_ sender: UIButton) {
        sender.transform = .identity
        sender.layer.shadowOpacity = 0.5
        print("filterButtonTapped")
    }

    @objc func holdDown(sender: UIButton) {
        sender.transform = CGAffineTransform(scaleX: 0.97, y: 0.97)
        sender.layer.shadowOpacity = 0
    }

    private func setupShadowOf(_ view: UIView, radius: CGFloat, opacity: Float ) {
        view.layer.shadowOffset = CGSize(width: 0, height: 3)
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowOpacity = opacity
        view.layer.shadowRadius = radius
    }
}

extension MonitorViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension MonitorViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.dateWithActivity.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MonitorCell.reuseIdentifier, for: indexPath) as? MonitorCell else {
            print("erreur de cell")
            return UITableViewCell()
        }

        let stringDate = viewModel.dateWithActivity[indexPath.row].toStringWithDayMonthYear()
        let legend = viewModel.summaryActivities[stringDate] ?? [:]

#warning("for test")
        typealias DataCell = (date: Date, elementsToLegend: [String:String])
        typealias GraphData = (elements: [GraphActivity], style: GraphType)

        let dataCell = DataCell(date: viewModel.dateWithActivity[indexPath.row], elementsToLegend: legend)
        let graphData = GraphData(elements: viewModel.graphActivities[stringDate]!, style: .ligne)

        cell.setUp(with: dataCell, graphData: graphData)
        return cell
    }
}

extension MonitorViewController {

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        let currentCategory = traitCollection.preferredContentSizeCategory
        let previousCategory = previousTraitCollection?.preferredContentSizeCategory

        guard currentCategory != previousCategory else { return }
        let isAccessibilityCategory = currentCategory.isAccessibilityCategory
        filterStackView.axis = isAccessibilityCategory ? .vertical : .horizontal
        }
}
