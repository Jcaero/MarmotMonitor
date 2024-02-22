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

    var viewModel = DetailGraphViewModel()
    private var delegate: UpdateInformationControllerDelegate?

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupContraints()

        setupTableView()
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
        view.addSubview(tableView)
        view.addSubview(settingTitle)
    }

    private func setupContraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        settingTitle.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            settingTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            settingTitle.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -30),
            settingTitle.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 30),

            tableView.topAnchor.constraint(equalTo: settingTitle.bottomAnchor, constant: 10),
            tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -30),
            tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 30),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30)
        ])
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRow
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

            self.viewModel.deleteActivity(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            self.delegate?.updateInformation()
            completionHandler(true)
        }

        return UISwipeActionsConfiguration(actions: [deleteAction])
    }

}
