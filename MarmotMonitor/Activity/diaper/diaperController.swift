//
//  diaperController.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 25/12/2023.
//

import UIKit

class DiaperController: ActivityController {
    let tableOfDiaper: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .duckBlue
        tableView.backgroundColor = .clear
        return tableView
    }()

    // MARK: - PROPERTIES
    var tableViewHeightConstraint: NSLayoutConstraint?
    var typeOfDiaper: [String] = ["Urine", "Souillée", "Mixte"]
    var statusOfDiaper: [Bool] = [false, false, false]

    // MARK: - Cycle life
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .colorForGradientStart

        setupViews()
        setupContraints()
        setupTimePickerAndLabel()

        setupTableView()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableOfDiaper.reloadData()
        setupTableViewHeight()
    }

    // MARK: - Setup function
    private func setupViews() {
        scrollArea.addSubview(tableOfDiaper)
    }

    private func setupContraints() {
        tableOfDiaper.translatesAutoresizingMaskIntoConstraints = false

        scrollViewTopConstraint?.constant = 30

        tableViewHeightConstraint = tableOfDiaper.heightAnchor.constraint(greaterThanOrEqualToConstant: 300)
        NSLayoutConstraint.activate([
            tableOfDiaper.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 15),
            tableOfDiaper.rightAnchor.constraint(equalTo: scrollArea.rightAnchor, constant: -10),
            tableOfDiaper.leftAnchor.constraint(equalTo: scrollArea.leftAnchor, constant: 10),
            tableViewHeightConstraint!,
            tableOfDiaper.bottomAnchor.constraint(equalTo: scrollArea.bottomAnchor, constant: -10)
        ])
    }

    private func setupTimePickerAndLabel() {
        timeLabel.text = "Etat de la couche"
        timeLabel.setAccessibility(with: .staticText, label: "heure de la couche", hint: "")

        timePicker.setAccessibility(with: .selected, label: "", hint: "choisir l'heure de la couche")
    }

    private func setupTableViewHeight() {
        var height: CGFloat = 0
        let cell = tableOfDiaper.cellForRow(at: IndexPath(row: 0, section: 0))
        height = cell?.contentView.frame.size.height ?? 0
        tableViewHeightConstraint?.constant = height * 3
        tableOfDiaper.layoutIfNeeded()
    }

    private func setupTableView() {
        tableOfDiaper.delegate = self
        tableOfDiaper.dataSource = self
        tableOfDiaper.rowHeight = UITableView.automaticDimension
        tableOfDiaper.register(DiaperCell.self, forCellReuseIdentifier: DiaperCell.reuseIdentifier)
    }
}

    extension DiaperController: UITableViewDelegate {
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let status = statusOfDiaper[indexPath.row]
            statusOfDiaper = [false, false, false]
            statusOfDiaper[indexPath.row] = !status
            tableView.reloadData()
        }
    }

extension DiaperController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return typeOfDiaper.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DiaperCell.reuseIdentifier, for: indexPath) as? DiaperCell else {
            print("erreur de cell")
            return UITableViewCell()
        }
        let type = typeOfDiaper[indexPath.row]
        let status = statusOfDiaper[indexPath.row]
        cell.setupCell(with: type, selected: status)
        cell.layoutMargins = UIEdgeInsets(top: 10, left: 8, bottom: 8, right: 8)
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
}
