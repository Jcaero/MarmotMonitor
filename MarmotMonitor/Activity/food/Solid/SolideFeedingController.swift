//
//  SolideFeedingController.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 18/12/2023.
//

import Foundation

import UIKit

class SolideFeedingController: UIViewController {
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isScrollEnabled = true
        scrollView.backgroundColor = .clear
        return scrollView
    }()

    let scrollArea: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()

    let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "Heure du debut"
        label.setupDynamicTextWith(policeName: "Symbol", size: 25, style: .body)
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = 0
        label.setAccessibility(with: .staticText, label: "heure de la tétée", hint: "")
        return label
    }()

    let timePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .dateAndTime
        datePicker.maximumDate = Date()
        datePicker.tintColor = .label
        datePicker.backgroundColor = .clear
        datePicker.setAccessibility(with: .selected, label: "", hint: "choisir l'heure de la tétée")
        return datePicker
    }()

    let separator: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()

    let tableOfIngredients: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .duckBlue
        tableView.backgroundColor = .clear
        return tableView
    }()

    let totalWeight: UILabel = {
        let label = UILabel()
        label.text = "Total: 0 g"
        label.setupDynamicTextWith(policeName: "Symbol", size: 20, style: .body)
        label.textColor = .label
        label.textAlignment = .center
        label.backgroundColor = .duckBlue
        label.layer.cornerRadius = 15
        label.clipsToBounds = true
        label.setAccessibility(with: .staticText, label: "total des solides", hint: "")
        return label
    }()

    lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Annuler", for: .normal)
        button.setTitleColor(.colorForDuckBlueToWhite, for: .normal)
        button.setupDynamicTextWith(policeName: "Symbol", size: 20, style: .body)
        button.addTarget(self, action: #selector(closeView), for: .touchUpInside)
        button.setAccessibility(with: .button, label: "Annuler les informations", hint: "")
        return button
    }()

    let valideButton: UIButton = {
        let button = UIButton()
        button.tintColor = .colorForDuckBlueToWhite
        button.setBackgroundImage(UIImage(systemName: "checkmark"), for: .normal)
        button.setAccessibility(with: .button, label: "valider les informations", hint: "")
        return button
    }()

    // MARK: - PROPERTIES
    var viewModel : SolidFeedingViewModel!

    var tableViewHeightConstraint: NSLayoutConstraint?

    var textFieldActif: UITextField?

    // MARK: - Cycle life
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .colorForGradientStart
        viewModel = SolidFeedingViewModel(delegate: self)

        setupViews()
        setupContraints()

        setupNavigationBar()
        setupTableView()

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableOfIngredients.reloadData()
        setupTableViewHeight()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Setup function
    private func setupViews() {
        [scrollView, cancelButton, valideButton].forEach {
            view.addSubview($0)
        }

        scrollView.addSubview(scrollArea)

        [timeLabel, timePicker, separator, tableOfIngredients, totalWeight].forEach {
            scrollArea.addSubview($0)
        }
    }

    private func setupContraints() {
        [timeLabel, timePicker, separator,
         tableOfIngredients,
         scrollArea, scrollView,
         totalWeight, valideButton, cancelButton ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            cancelButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20)
        ])

        NSLayoutConstraint.activate([
            valideButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            valideButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            valideButton.widthAnchor.constraint(equalTo: valideButton.heightAnchor),
            valideButton.heightAnchor.constraint(equalTo: cancelButton.heightAnchor)
        ])

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: cancelButton.topAnchor, constant: -10),
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])

        NSLayoutConstraint.activate([
            scrollArea.topAnchor.constraint(equalTo: scrollView.topAnchor),
            scrollArea.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -10),
            scrollArea.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 10),
            scrollArea.widthAnchor.constraint(equalToConstant: (view.frame.width - 20))
        ])

        NSLayoutConstraint.activate([
            timeLabel.topAnchor.constraint(equalTo: scrollArea.topAnchor),
            timeLabel.rightAnchor.constraint(equalTo: scrollArea.rightAnchor, constant: -20),
            timeLabel.leftAnchor.constraint(equalTo: scrollArea.leftAnchor, constant: 20)
        ])

        NSLayoutConstraint.activate([
            timePicker.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 15),
            timePicker.centerXAnchor.constraint(equalTo: scrollArea.centerXAnchor),
            timePicker.leftAnchor.constraint(greaterThanOrEqualTo: scrollArea.leftAnchor, constant: 20)
        ])

        NSLayoutConstraint.activate([
            separator.topAnchor.constraint(equalTo: timePicker.bottomAnchor, constant: 15),
            separator.centerXAnchor.constraint(equalTo: scrollArea.centerXAnchor),
            separator.widthAnchor.constraint(equalTo: scrollArea.widthAnchor, multiplier: 0.8),
            separator.heightAnchor.constraint(equalToConstant: 2)
        ])

        tableViewHeightConstraint = tableOfIngredients.heightAnchor.constraint(greaterThanOrEqualToConstant: 300)
        NSLayoutConstraint.activate([
            tableOfIngredients.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 15),
            tableOfIngredients.rightAnchor.constraint(equalTo: scrollArea.rightAnchor, constant: -10),
            tableOfIngredients.leftAnchor.constraint(equalTo: scrollArea.leftAnchor, constant: 10),
            tableViewHeightConstraint!
        ])

        NSLayoutConstraint.activate([
            totalWeight.topAnchor.constraint(equalTo: tableOfIngredients.bottomAnchor, constant: 10),
            totalWeight.centerXAnchor.constraint(equalTo: scrollArea.centerXAnchor),
            totalWeight.widthAnchor.constraint(equalTo: scrollArea.widthAnchor, multiplier: 0.75),
            totalWeight.heightAnchor.constraint(greaterThanOrEqualToConstant: 50),
            totalWeight.bottomAnchor.constraint(equalTo: scrollArea.bottomAnchor, constant: -10)
        ])
    }

    private func setupTableViewHeight() {
        var height: CGFloat = 0
        for index in 0..<viewModel.ingredients.count-1 {
            let cell = tableOfIngredients.cellForRow(at: IndexPath(row: index, section: 0))
            let cellHeight = cell?.contentView.frame.size.height ?? 0
            if cellHeight > height {
                height = cellHeight
            }
        }
        tableViewHeightConstraint?.constant = height * CGFloat(viewModel.ingredients.count-1)
        tableOfIngredients.layoutIfNeeded()
    }

    private func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .none
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }

    private func setupTableView() {
        tableOfIngredients.delegate = self
        tableOfIngredients.dataSource = self
        tableOfIngredients.rowHeight = UITableView.automaticDimension
        tableOfIngredients.register(SolideCell.self, forCellReuseIdentifier: SolideCell.reuseIdentifier)
    }

    // MARK: - Action

    @objc private func closeView() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension SolideFeedingController: UITableViewDelegate {
}

extension SolideFeedingController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.ingredients.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SolideCell.reuseIdentifier, for: indexPath) as? SolideCell else {
            print("erreur de cell")
            return UITableViewCell()
        }
        let ingredient = viewModel.ingredients[indexPath.row]
        let poids = viewModel.solidFood[ingredient] ?? 0
        cell.setupCell(with: ingredient, value: poids)
        cell.layoutMargins = UIEdgeInsets(top: 10, left: 8, bottom: 8, right: 8)
        cell.selectionStyle = .none
        cell.poidsTF.tag = indexPath.row
        cell.poidsTF.delegate = self
        return cell
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
}

// MARK: - UITextFieldDelegate
extension SolideFeedingController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textFieldActif = textField
        textField.addTarget(self, action: #selector(valueChanged), for: .editingChanged)
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.removeTarget(self, action: #selector(valueChanged), for: .editingChanged)
        viewModel.updateTotal()

        textFieldActif = nil
        textField.resignFirstResponder()
    }

    @objc func valueChanged(_ textField: UITextField) {
        let ingredient = viewModel.ingredients[textField.tag]
        viewModel.set(textField.text ?? "", for: ingredient)
    }
}

extension SolideFeedingController: SolideFeedingProtocol {
    func updateTotal(with total: String) {
        totalWeight.text = total
    }
}

extension SolideFeedingController {
    // MARK: - Keyboard
    /// Check if the keyboard is displayed above textefield  and move the view if necessary
    @objc func keyboardWillShow(notification: NSNotification) {
        if let clavierTaille = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
           let textFieldActif = textFieldActif {

            let frameDuTextField = view.convert(textFieldActif.frame, from: textFieldActif.superview)
            let distanceDuBas = view.frame.height - frameDuTextField.maxY

            if distanceDuBas < clavierTaille.height {
                let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: self.view.frame.height/2 - distanceDuBas , right: 0)
                tableOfIngredients.contentInset = contentInset
                tableOfIngredients.scrollIndicatorInsets = contentInset
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        tableOfIngredients.contentInset = .zero
        tableOfIngredients.scrollIndicatorInsets = .zero
    }
}
