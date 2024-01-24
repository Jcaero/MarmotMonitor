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
        tableView.backgroundColor = .colorForPastelArea
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .singleLine
        tableView.layer.cornerRadius = 20
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupContraints()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MonitorCell.self, forCellReuseIdentifier: MonitorCell.reuseIdentifier)
    }

    let date = ["07/11/2023".toDate()!, "08/11/2023".toDate()!, "09/11/2023".toDate()!]

    //  MARK: - Setup views

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
}

extension MonitorViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MonitorCell.reuseIdentifier, for: indexPath) as? MonitorCell else {
            print("erreur de cell")
            return UITableViewCell()
        }
        // test
        if indexPath.row == 0 {
            cell.setupCell(with: date[indexPath.row], elements: [], style: .rod)
        } else if indexPath.row == 1  {
            cell.setupCell(with: date[indexPath.row], elements: [], style: .round)
        } else {
            cell.setupCell(with: date[indexPath.row], elements: [], style: .ligne)
        }
        return cell
    }
}
