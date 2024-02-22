//
//  DetailGraphViewController.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 21/02/2024.
//

import UIKit

class DetailGraphViewController: BackgroundViewController, UITableViewDelegate, UITableViewDataSource {

    let settingTitle: UILabel = {
        let label = UILabel()
        label.setupDynamicBoldTextWith(policeName: "Symbol", size: 34, style: .largeTitle)
        label.textColor = .label
        label.textAlignment = .natural
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()

    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.layer.cornerRadius = 20
        tableView.setupShadow(radius: 1, opacity: 0.5)
        tableView.clipsToBounds = true
        tableView.register(DetailGraphCell.self, forCellReuseIdentifier: DetailGraphCell.reuseIdentifier)
        return tableView
    }()

    private let cancelButton: UIButton = {
        let button = UIButton()
        button.createActionButton(type: .retour)
        button.layer.cornerRadius = 10
        button.setTitle("Retour", for: .normal)
        button.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        return button
    }()

    var viewModel = DetailGraphViewModel()
    private var delegate: UpdateInformationControllerDelegate?

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupContraints()

        setupTableView()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    init(title: String, data: [GraphActivity], delegate: UpdateInformationControllerDelegate) {
        super.init(nibName: nil, bundle: nil)
        settingTitle.text = title
        viewModel.setDatas(data: data)
        self.delegate = delegate
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup Views
    private func setupViews() {
        [cancelButton, tableView, settingTitle].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    private func setupContraints() {
        NSLayoutConstraint.activate([
            settingTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            settingTitle.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -30),
            settingTitle.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 30),

            cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            cancelButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -30),
            cancelButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 30),

            tableView.topAnchor.constraint(equalTo: settingTitle.bottomAnchor, constant: 10),
            tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -30),
            tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 30),
            tableView.bottomAnchor.constraint(equalTo: cancelButton.topAnchor)
        ])
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRow
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailGraphCell.reuseIdentifier, for: indexPath) as? DetailGraphCell else {
            print("erreur de cell")
            return UITableViewCell()
        }
        let activity = viewModel.data[indexPath.row].type
        let value = viewModel.getValue(for: indexPath.row)
        let date = viewModel.data[indexPath.row].timeStart

        cell.configure(with: activity, value: value, date: date)
        return cell
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Supprimer") { (_, _, completionHandler) in

            self.viewModel.deleteActivity(at: indexPath.row) {
                tableView.deleteRows(at: [indexPath], with: .automatic)
                self.delegate?.updateInformation()
                completionHandler(true)
            }
            completionHandler(false)
        }

        return UISwipeActionsConfiguration(actions: [deleteAction])
    }

    // MARK: - button action
    @objc func cancel(sender: UIButton) {
    self.dismiss(animated: true, completion: nil)
    }
}
