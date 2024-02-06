//
//  SettingViewController.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 03/02/2024.
//

import UIKit

class SettingViewController: BackgroundViewController {

    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .clear
        scrollView.layer.cornerRadius = 20
        return scrollView
    }()

    let pastelArea: UIView = {
        let view = UIView()
        view.backgroundColor = .colorForPastelArea
        view.layer.cornerRadius = 20
        return view
    }()

    let settingTitle: UILabel = {
        let label = UILabel()
        label.text = "Paramètres"
        label.setupDynamicTextWith(policeName: "Symbol", size: 30, style: .title3)
        label.textColor = .colorForLabelBlackToBlue
        label.textAlignment = .left
        label.setupShadow(radius: 1, opacity: 0.2)
        label.numberOfLines = 0
        return label
    }()

    let subTitle: UILabel = {
        let label = UILabel()
        label.text = "Information"
        label.setupDynamicTextWith(policeName: "Symbol", size: 20, style: .body)
        label.textColor = .label
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()

    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.layer.cornerRadius = 20
        return tableView
    }()

    let viewModel = SettingViewModel()

    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupContraints()

        viewModel.getUserInformation()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(InformationUserSetting.self, forCellReuseIdentifier: InformationUserSetting.reuseIdentifier)

        tableView.rowHeight = UITableView.automaticDimension
        tableView.sectionHeaderHeight = UITableView.automaticDimension
    }

    private func setupViews() {
        view.backgroundColor = .white

        [settingTitle, tableView].forEach {
            view.addSubview($0)
        }

    }

    private func setupContraints() {
        [settingTitle, tableView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            settingTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            settingTitle.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            settingTitle.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),

            tableView.topAnchor.constraint(equalTo:settingTitle.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10)
        ])
    }
}

extension SettingViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return 5
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: InformationUserSetting.reuseIdentifier, for: indexPath) as? InformationUserSetting else {
                print("erreur de cell")
                return UITableViewCell()
            }
            cell.setupTitle(with: viewModel.babyName, birthDay: viewModel.birthDay, parent: viewModel.parentName)
            cell.backgroundColor = .clear
            return cell

        default:
            let kCellId = "kCellId"
            var lCell = tableView.dequeueReusableCell(withIdentifier: kCellId)
            if lCell == nil {
                lCell = UITableViewCell(style: .default, reuseIdentifier: kCellId)
                lCell?.textLabel?.text = "Row - \(indexPath.row)"
            }
            lCell?.backgroundColor = .orange
            return lCell!
        }
    }

    internal func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = HeaderSettingView()

        switch section {
        case 0:
            let view = UIView()
            view.backgroundColor = .clear
            return view
        default:
            headerView.setupTitle(with: "Header \(section)")
            return headerView
        }
    }

    /// Set the corner radius for the first and last cell of the table view
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let isLastCell = tableView.numberOfRows(inSection: indexPath.section)-1 == indexPath.row
        let firstCell = indexPath.row == 0
        if isLastCell {
            cell.applyCorners(position: [.bottomLeft, .bottomRight], with: cell.bounds)
        } else if firstCell {
            cell.applyCorners(position: [.topLeft, .topRight], with: cell.bounds)
        } else {
            cell.noCorners()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            let next = InformationViewController(delegate: self)
            present(next, animated: true, completion: nil)
        default:
            break
        }
    }
}

extension SettingViewController {
 override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        tableView.reloadData()
    }
}

extension SettingViewController: InformationViewControllerDelegate {
    func updateInformation() {
        viewModel.getUserInformation()
        tableView.reloadData()
    }
}
