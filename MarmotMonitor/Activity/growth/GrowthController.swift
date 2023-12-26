//
//  GrowthController.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 26/12/2023.
//
//
//  SolideFeedingController.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 18/12/2023.
//
import UIKit

class GrowthController: ActivityController {
    let tableOfGrowth: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .duckBlue
        tableView.backgroundColor = .clear
        return tableView
    }()

    // MARK: - PROPERTIES
    var tableViewHeightConstraint: NSLayoutConstraint?

    var textFieldActif: UITextField?

    let category: [String] = ["Taille", "Poids", "Tête"]
    var growth : [String : Int] = [:]

    // MARK: - Cycle life
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .colorForGradientStart

        setupViews()
        setupContraints()
        setupTimePickerAndLabel()

        setupTableView()

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableOfGrowth.reloadData()
        setupTableViewHeight()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Setup function
    private func setupViews() {
        scrollArea.addSubview(tableOfGrowth)
    }

    private func setupContraints() {
            tableOfGrowth.translatesAutoresizingMaskIntoConstraints = false

        tableViewHeightConstraint = tableOfGrowth.heightAnchor.constraint(greaterThanOrEqualToConstant: 300)
        NSLayoutConstraint.activate([
            tableOfGrowth.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 15),
            tableOfGrowth.rightAnchor.constraint(equalTo: scrollArea.rightAnchor, constant: -10),
            tableOfGrowth.leftAnchor.constraint(equalTo: scrollArea.leftAnchor, constant: 10),
            tableViewHeightConstraint!,
            tableOfGrowth.bottomAnchor.constraint(equalTo: scrollArea.bottomAnchor, constant: -10)
        ])
    }

    private func setupTimePickerAndLabel() {
        timeLabel.text = "Date"
        timeLabel.setAccessibility(with: .staticText, label: "date de la mesure", hint: "")

        timePicker.setAccessibility(with: .selected, label: "", hint: "choisir la date de la mesure")
    }

    private func setupTableViewHeight() {
        var height: CGFloat = 0
        for index in 0..<category.count-1 {
            let cell = tableOfGrowth.cellForRow(at: IndexPath(row: index, section: 0))
            let cellHeight = cell?.contentView.frame.size.height ?? 0
            if cellHeight > height {
                height = cellHeight
            }
        }
        tableViewHeightConstraint?.constant = height * CGFloat(category.count)
        tableOfGrowth.layoutIfNeeded()
    }

    private func setupTableView() {
        tableOfGrowth.delegate = self
        tableOfGrowth.dataSource = self
        tableOfGrowth.rowHeight = UITableView.automaticDimension
        tableOfGrowth.register(GrowthCell.self, forCellReuseIdentifier: GrowthCell.reuseIdentifier)
    }
}

extension GrowthController: UITableViewDelegate {
}

extension GrowthController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return category.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GrowthCell.reuseIdentifier, for: indexPath) as? GrowthCell else {
            print("erreur de cell")
            return UITableViewCell()
        }
        let category = category[indexPath.row]
        let value = growth[category] ?? 0
        cell.setupCell(with: category, value: value)
        cell.layoutMargins = UIEdgeInsets(top: 10, left: 8, bottom: 8, right: 8)
        cell.selectionStyle = .none
        cell.valueTF.tag = indexPath.row
        cell.valueTF.delegate = self
        return cell
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
}

// MARK: - UITextFieldDelegate
extension GrowthController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textFieldActif = textField
        textField.addTarget(self, action: #selector(valueChanged), for: .editingChanged)
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.removeTarget(self, action: #selector(valueChanged), for: .editingChanged)

        textFieldActif = nil
        textField.resignFirstResponder()
        self.tableOfGrowth.reloadData()
    }

    @objc func valueChanged(_ textField: UITextField) {
        let category = category[textField.tag]

        guard let value = Int(textField.text ?? "") else { return }
        growth[category] = value
    }
}

extension GrowthController {
    // MARK: - Keyboard
    /// Check if the keyboard is displayed above textefield  and move the view if necessary
    @objc func keyboardWillShow(notification: NSNotification) {
        if let clavierTaille = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
           let textFieldActif = textFieldActif {

            let frameDuTextField = view.convert(textFieldActif.frame, from: textFieldActif.superview)
            let distanceDuBas = view.frame.height - frameDuTextField.maxY

            if distanceDuBas < clavierTaille.height {
                let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: self.view.frame.height/2 - distanceDuBas , right: 0)
                tableOfGrowth.contentInset = contentInset
                tableOfGrowth.scrollIndicatorInsets = contentInset
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        tableOfGrowth.contentInset = .zero
        tableOfGrowth.scrollIndicatorInsets = .zero
    }
}
