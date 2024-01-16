//
//  SleepController.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 22/12/2023.
//

import UIKit

class SleepController: BackGroundActivity, SleepDelegate {

    let titleLabel: UILabel = {
        let label = UILabel()
        label.setupDynamicTextWith(policeName: "Symbol", size: 30, style: .body)
        label.text = "Sommeil"
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = 1
        label.setAccessibility(with: .header, label: "Sommeil", hint: "")
        return label
    }()

    let tableOfSleepData: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .duckBlue
        tableView.backgroundColor = .clear
        return tableView
    }()

    let stopTimePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .dateAndTime
        datePicker.maximumDate = Date()
        datePicker.tintColor = .label
        datePicker.backgroundColor = .duckBlue
        datePicker.setAccessibility(with: .selected, label: "", hint: "choisir l'heure de la tétée")
        return datePicker
    }()

    let doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Done", for: .normal)
        button.setTitleColor(.label, for: .normal)
        return button
    }()

    // MARK: - PROPERTIES
    var viewModel : SleepViewModel!

    var tableViewHeightConstraint: NSLayoutConstraint?

    // MARK: - Cycle life
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = SleepViewModel(delegate: self)

        setupViews()
        setupContraints()

        setupTableView()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableOfSleepData.reloadData()
        setupTableViewHeight()
    }

    // MARK: - Setup function
    private func setupViews() {
        [titleLabel, tableOfSleepData].forEach {
            scrollArea.addSubview($0)
        }
    }

    private func setupContraints() {
        [titleLabel,tableOfSleepData].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: scrollArea.topAnchor, constant: 50),
            titleLabel.rightAnchor.constraint(equalTo: scrollArea.rightAnchor, constant: -10),
            titleLabel.leftAnchor.constraint(equalTo: scrollArea.leftAnchor, constant: 10)
        ])

        tableViewHeightConstraint = tableOfSleepData.heightAnchor.constraint(greaterThanOrEqualToConstant: 300)
        NSLayoutConstraint.activate([
            tableOfSleepData.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
            tableOfSleepData.rightAnchor.constraint(equalTo: scrollArea.rightAnchor, constant: -10),
            tableOfSleepData.leftAnchor.constraint(equalTo: scrollArea.leftAnchor, constant: 10),
            tableViewHeightConstraint!,
            tableOfSleepData.bottomAnchor.constraint(equalTo: scrollArea.bottomAnchor, constant: -10)
        ])
    }

    private func setupTableViewHeight() {
        var height: CGFloat = 0
        let cell = tableOfSleepData.cellForRow(at: IndexPath(row: 0, section: 0))
        let cellHeight = cell?.contentView.frame.size.height ?? 0
        if cellHeight > height {
            height = cellHeight
        }
        tableViewHeightConstraint?.constant = height * 2
        tableOfSleepData.layoutIfNeeded()
    }

    private func setupTableView() {
        tableOfSleepData.delegate = self
        tableOfSleepData.dataSource = self
        tableOfSleepData.rowHeight = UITableView.automaticDimension
        tableOfSleepData.register(SleepCell.self, forCellReuseIdentifier: SleepCell.reuseIdentifier)
    }
}

extension SleepController {
    private func setupTapGesture(with label: UILabel) {
        label.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showDatePicker))
        label.addGestureRecognizer(tapGesture)
    }

    @objc func showDatePicker(_ sender: UITapGestureRecognizer) {
        // save the label which is selected
        if let label = sender.view as? UILabel {
            viewModel.setSelectedLabel(with: label.tag)
        }

        // put the datePicker on the view
        stopTimePicker.frame = CGRect(x: 0, y: self.view.frame.height - 300, width: self.view.frame.width, height: 300)
        self.view.addSubview(stopTimePicker)

        // Done button for closing datepicker
        doneButton.frame = CGRect(x: self.view.frame.width - 70, y: self.view.frame.height - 300, width: 70, height: 30)
        doneButton.addTarget(self, action: #selector(dismissDatePicker), for: .touchUpInside)
        self.view.addSubview(doneButton)
    }

    @objc func dismissDatePicker() {
        viewModel.setDate(with: stopTimePicker.date)

        stopTimePicker.removeFromSuperview()
        if let doneButton = self.view.subviews.first(where: { $0 is UIButton && ($0 as? UIButton)?.currentTitle == "Done" }) {
            doneButton.removeFromSuperview()
        }
    }

    func updateData() {
        tableOfSleepData.reloadData()
    }
}

extension SleepController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SleepCell.reuseIdentifier, for: indexPath) as? SleepCell else {
            print("erreur de cell")
            return UITableViewCell()
        }
        let title = indexPath.row == 0 ? "Heure de début" : "Heure de fin"
        cell.setupCell(with: "\(title)", date: viewModel.dateData[indexPath.row])
        cell.layoutMargins = UIEdgeInsets(top: 10, left: 8, bottom: 8, right: 8)
        cell.selectionStyle = .none
        cell.dateLabel.tag = indexPath.row
        setupTapGesture(with: cell.dateLabel)
        return cell
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
