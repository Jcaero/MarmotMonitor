//
//  SleepController.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 22/12/2023.
//

import UIKit

class SleepController: BackGroundActivity {

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

    let tableOfIngredients: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .duckBlue
        tableView.backgroundColor = .clear
        return tableView
    }()

    let stopTimePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .dateAndTime
        datePicker.maximumDate = Date()
        datePicker.tintColor = .label
        datePicker.backgroundColor = .clear
        datePicker.setAccessibility(with: .selected, label: "", hint: "choisir l'heure de la tétée")
        return datePicker
    }()

    // MARK: - PROPERTIES
    var tableViewHeightConstraint: NSLayoutConstraint?
    var dateData: [String] = ["Pas encore de date","Pas encore de date"]

    var selectedLabel: Int = 0 {
        didSet {
            if selectedLabel == 0 {
                tableOfIngredients.reloadData()
            }
        }
    }

    // MARK: - Cycle life
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupContraints()

        setupTableView()
    }

    // MARK: - Setup function
    private func setupViews() {
        [titleLabel, tableOfIngredients].forEach {
            scrollArea.addSubview($0)
        }
    }

    private func setupContraints() {
        [titleLabel,tableOfIngredients].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: scrollArea.topAnchor, constant: 50),
            titleLabel.rightAnchor.constraint(equalTo: scrollArea.rightAnchor, constant: -10),
            titleLabel.leftAnchor.constraint(equalTo: scrollArea.leftAnchor, constant: 10)
        ])

        tableViewHeightConstraint = tableOfIngredients.heightAnchor.constraint(greaterThanOrEqualToConstant: 300)
        NSLayoutConstraint.activate([
            tableOfIngredients.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
            tableOfIngredients.rightAnchor.constraint(equalTo: scrollArea.rightAnchor, constant: -10),
            tableOfIngredients.leftAnchor.constraint(equalTo: scrollArea.leftAnchor, constant: 10),
            tableViewHeightConstraint!,
            tableOfIngredients.bottomAnchor.constraint(equalTo: scrollArea.bottomAnchor, constant: -10)
        ])
    }

    private func setupTableViewHeight() {
        var height: CGFloat = 0
        let cell = tableOfIngredients.cellForRow(at: IndexPath(row: 1, section: 0))
        let cellHeight = cell?.contentView.frame.size.height ?? 0
        if cellHeight > height {
            height = cellHeight
        }
        tableViewHeightConstraint?.constant = height * 2
        tableOfIngredients.layoutIfNeeded()
    }

    private func setupTableView() {
        tableOfIngredients.delegate = self
        tableOfIngredients.dataSource = self
        tableOfIngredients.rowHeight = UITableView.automaticDimension
        tableOfIngredients.register(SleepCell.self, forCellReuseIdentifier: SleepCell.reuseIdentifier)
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
            selectedLabel = label.tag
        }

        // Configurez le datePicker comme vous le souhaitez
        stopTimePicker.datePickerMode = .date
        stopTimePicker.preferredDatePickerStyle = .wheels // ou .automatic pour le style par défaut
        stopTimePicker.backgroundColor = UIColor.white

        // put the datePicker on the view
        stopTimePicker.frame = CGRect(x: 0, y: self.view.frame.height - 300, width: self.view.frame.width, height: 300)
        self.view.addSubview(stopTimePicker)

        // Done button for closing datepicker
        let doneButton = UIButton(type: .system)
        doneButton.frame = CGRect(x: self.view.frame.width - 70, y: self.view.frame.height - 300, width: 70, height: 30)
        doneButton.setTitle("Done", for: .normal)
        doneButton.addTarget(self, action: #selector(dismissDatePicker), for: .touchUpInside)
        self.view.addSubview(doneButton)
    }

    @objc func dismissDatePicker() {
        // Fermez le datePicker et le bouton 'Done'
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let dateTexte = dateFormatter.string(from: stopTimePicker.date)
        dateData[selectedLabel] = dateTexte
        selectedLabel = 0
        stopTimePicker.removeFromSuperview()
        if let doneButton = self.view.subviews.first(where: { $0 is UIButton && ($0 as! UIButton).currentTitle == "Done" }) {
            doneButton.removeFromSuperview()
        }
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
        cell.setupCell(with: "\(title)", date: dateData[indexPath.row])
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
