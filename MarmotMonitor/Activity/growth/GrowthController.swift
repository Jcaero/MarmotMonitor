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
/// GrowthController
/// This class is used to insert growth element
/// The user can put the weight and the size of the baby
final class GrowthController: ActivityController, GrowthDelegate {
    let tableOfGrowth: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .duckBlue
        tableView.backgroundColor = .clear
        return tableView
    }()

    // MARK: - PROPERTIES
    private var viewModel: GrowthViewModel!
    private var tableViewHeightConstraint: NSLayoutConstraint?

    private var textFieldActif: UITextField?

    // MARK: - Cycle life
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = GrowthViewModel(delegate: self)

        view.backgroundColor = .colorForGradientStart

        setupViews()
        setupContraints()

        setupTimePickerAndLabel()
        setupValideButton()

        setupTableView()

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
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

        scrollViewTopConstraint?.constant = 30

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
        timeLabel.setAccessibility(with: .staticText, label: "page de gestion de la croissance", hint: "")

        timePicker.setAccessibility(with: .selected, label: "", hint: "choisir la date de la mesure")
    }

    private func setupValideButton() {
        valideButton.setAccessibility(with: .button, label: "Valider", hint: "Valider la croissance")
        valideButton.addTarget(self, action: #selector(valideButtonSet), for: .touchUpInside)
    }

    @objc func valideButtonSet() {
        viewModel.saveGrowth(at: timePicker.date)
    }

    private func setupTableViewHeight() {
        var height: CGFloat = 0
        for index in 0..<viewModel.category.count-1 {
            let cell = tableOfGrowth.cellForRow(at: IndexPath(row: index, section: 0))
            let cellHeight = cell?.contentView.frame.size.height ?? 0
            if cellHeight > height {
                height = cellHeight
            }
        }
        tableViewHeightConstraint?.constant = height * CGFloat(viewModel.category.count)
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
        return viewModel.category.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GrowthCell.reuseIdentifier, for: indexPath) as? GrowthCell else {
            print("erreur de cell")
            return UITableViewCell()
        }
        let category = viewModel.category[indexPath.row]
        let value = viewModel.growthData[category.title] ?? 0
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
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        viewModel.setGrowth(with: textField.text, inPosition: textField.tag)

        textFieldActif = nil
        textField.resignFirstResponder()
    }

    @objc func valueChanged(_ textField: UITextField) {
        viewModel.setGrowth(with: textField.text, inPosition: textField.tag)
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
