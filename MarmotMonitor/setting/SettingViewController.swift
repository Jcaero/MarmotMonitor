//
//  SettingViewController.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 03/02/2024.
//

import UIKit
protocol UpdateInformationControllerDelegate: AnyObject {
    func updateInformation()
}

class SettingViewController: BackgroundViewController, UpdateInformationControllerDelegate {
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

    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.layer.cornerRadius = 20
        tableView.setupShadow(radius: 1, opacity: 0.5)
        tableView.clipsToBounds = true
        tableView.accessibilityIdentifier = "SettingTableView"
        tableView.register(InformationUserSetting.self, forCellReuseIdentifier: InformationUserSetting.reuseIdentifier)
        tableView.register(SettingCell.self, forCellReuseIdentifier: SettingCell.reuseIdentifier)
        return tableView
    }()

    let viewModel = SettingViewModel()

    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupContraints()

        tableView.delegate = self
        tableView.dataSource = self
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
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15)
        ])
    }
}

extension SettingViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : 4
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            return configureInformationUserSettingCell(for: indexPath)

        case 1:
            switch indexPath.row {
            case 0:
                return configureGraphCell(for: indexPath)
            case 1:
                return configureIconeCell(for: indexPath)
            case 2:
                return configureApparenceCell(for: indexPath)
            case 3:
                return configureClearCoreDataCell(for: indexPath)
            default:
                return UITableViewCell()
            }

        default:
            return UITableViewCell()
        }
    }

    // MARK: - configuration cell
    private func configureInformationUserSettingCell(for indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: InformationUserSetting.reuseIdentifier, for: indexPath) as? InformationUserSetting else {
            return UITableViewCell()
        }
        cell.setupTitle(with: viewModel.babyName, birthDay: viewModel.birthDay, parent: viewModel.parentName)
        cell.backgroundColor = .clear
        cell.accessibilityIdentifier = "MyCell_Information"
        return cell
    }

    private func configureGraphCell(for indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingCell.reuseIdentifier, for: indexPath) as? SettingCell else {
            return UITableViewCell()
        }
        cell.setupTitle(with: "Type de graphique", information: viewModel.graphType.description, icone: UIImage(named: "graphIcone")!)
        cell.backgroundColor = .colorForGraphBackground
        cell.accessibilityIdentifier = "MyCell_graphType"
        cell.accessibilityLabel = "Type de graphique actuelement sélectionné : \(viewModel.graphType.description)"
        cell.layoutIfNeeded()
        return cell
    }

    private func configureIconeCell(for indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingCell.reuseIdentifier, for: indexPath) as? SettingCell else {
            return UITableViewCell()
        }
        cell.setupTitle(with: "Couleur d'Icone", information: "", icone: UIImage(named: viewModel.iconImageName)!)
        cell.accessibilityLabel = "Type d'icone' actuelle : \(viewModel.iconImageName)"
        cell.backgroundColor = .colorForGraphBackground
        cell.accessibilityIdentifier = "MyCell_IconeCouleur"
        return cell
    }

    private func configureApparenceCell(for indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingCell.reuseIdentifier, for: indexPath) as? SettingCell else {
            return UITableViewCell()
        }
        cell.setupTitle(with: "Apparence", information: viewModel.apparenceStyle, icone: UIImage(systemName: "iphone")!)
        cell.backgroundColor = .colorForGraphBackground
        cell.accessibilityIdentifier = "MyCell_Apparence"
        return cell
    }

    private func configureClearCoreDataCell(for indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingCell.reuseIdentifier, for: indexPath) as? SettingCell else {
            return UITableViewCell()
        }
        cell.setupTitle(with: "Effacer les Données", information: "", icone: UIImage(systemName: "eraser")!)
        cell.backgroundColor = .colorForGraphBackground
        cell.accessibilityIdentifier = "MyCell_ClearALLData"
        return cell
    }

    // MARK: - tableViewSetting
    internal func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let view = UIView()
            view.backgroundColor = .clear
            return view
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
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                let next = InformationViewController(delegate: self)
                present(next, animated: true, completion: nil)
            default:
                break
            }
        } else {
            switch indexPath.row {
            case 0:
                let next = GraphtypeViewController(delegate: self)
                present(next, animated: true, completion: nil)
            case 1:
                let next = IconSettingViewController(delegate: self)
                present(next, animated: true, completion: nil)
            case 2:
                let next = ApparenceSettingViewController(delegate: self)
                present(next, animated: true, completion: nil)
            case 3:
                clearCoreData()
            default:
                break
            }
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 5
        default:
            return 10
        }
    }

    // MARK: - core data clear
    private func clearCoreData() {
        let alert = UIAlertController(title: "Effacer les données", message: "Voulez-vous vraiment effacer toutes les données ?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Oui", style: .destructive, handler: { _ in
            self.viewModel.clearCoreData()
        }))
        alert.addAction(UIAlertAction(title: "Non", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
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
        tableView.reloadData()
    }
}
