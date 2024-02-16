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
        tableView.setupShadow(radius: 1, opacity: 0.5)
        tableView.clipsToBounds = true
        tableView.accessibilityIdentifier = "SettingTableView"
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
        tableView.register(SettingCell.self, forCellReuseIdentifier: SettingCell.reuseIdentifier)

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
        if section == 0 {
            return 1
        } else {
            return 3
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

        case 1:
            switch indexPath.row {
                case 0:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingCell.reuseIdentifier, for: indexPath) as? SettingCell else {
                    print("erreur de cell")
                    return UITableViewCell()
                }
                cell.setupTitle(with: "Type de graphique", information: viewModel.graphType.description, icone: UIImage(named: "graphIcone")!)
                cell.backgroundColor = .colorForGraphBackground
                cell.accessibilityIdentifier = "MyCell_graphType"
                return cell

            case 1:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingCell.reuseIdentifier, for: indexPath) as? SettingCell else {
                    print("erreur de cell")
                    return UITableViewCell()
                }
                cell.setupTitle(with: "Couleur d'Icone", information: "", icone: UIImage(named: viewModel.iconImageName)!)
                cell.backgroundColor = .colorForGraphBackground
                cell.accessibilityIdentifier = "MyCell_IconeCouleur"
                return cell

            case 2:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingCell.reuseIdentifier, for: indexPath) as? SettingCell else {
                    print("erreur de cell")
                    return UITableViewCell()
                }
                cell.setupTitle(with: "Apparence", information: viewModel.apparenceStyle, icone: UIImage(systemName: "iphone")!)
                cell.backgroundColor = .colorForGraphBackground
                cell.accessibilityIdentifier = "MyCell_Apparence"
                return cell

            default:
                let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
                cell.textLabel?.text = "Row - \(indexPath.row)"
                cell.backgroundColor = .colorForGraphBackground
                return cell
            }

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
