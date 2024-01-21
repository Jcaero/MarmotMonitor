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

    var viewModel : DiaperViewModel!

    // MARK: - Cycle life
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = DiaperViewModel(delegate: self)

        view.backgroundColor = .colorForGradientStart

        setupViews()
        setupContraints()

        setupTimePickerAndLabel()
        setupValideButton()

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

    private func setupValideButton() {
        valideButton.setAccessibility(with: .button, label: "Valider", hint: "Valider le choix de la couche")
        valideButton.addTarget(self, action: #selector(valideButtonSet), for: .touchUpInside)
    }

    @objc func valideButtonSet() {
        viewModel.saveDiaper(at: timePicker.date)
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
        let diaper = viewModel.diaperStates[indexPath.row]
        viewModel.selectDiaper(diaper: diaper)
    }
}

extension DiaperController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.diaperStates.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DiaperCell.reuseIdentifier, for: indexPath) as? DiaperCell else {
            print("erreur de cell")
            return UITableViewCell()
        }
        let type = viewModel.diaperStates[indexPath.row]
        let status = viewModel.diaperStatus[type]!
        cell.setupCell(with: type.rawValue, selected: status)
        cell.layoutMargins = UIEdgeInsets(top: 10, left: 8, bottom: 8, right: 8)
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
}

extension DiaperController: DiaperDelegate {
    func alert(title: String, description: String) {
        let alertVC = UIAlertController(title: title, message: description, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }

    func updateData() {
        tableOfDiaper.reloadData()
    }

    func nextView() {
        self.dismiss(animated: true, completion: nil)
    }
}
