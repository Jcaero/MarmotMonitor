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

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupContraints()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MonitorCell.self, forCellReuseIdentifier: MonitorCell.reuseIdentifier)
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
    }

    private func setupContraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
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
        cell.setupCell(with:  viewModel.dateWithActivity[indexPath.row], elementsToGraph: viewModel.graphActivities[stringDate]!, style: .ligne, elementsToLegend: legend)
        return cell
    }
}
