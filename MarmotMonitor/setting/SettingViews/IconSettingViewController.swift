//
//  IconSettingViewController.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 10/02/2024.
//

import UIKit

class IconSettingViewController: BackgroundViewController, UITableViewDelegate, UITableViewDataSource {
    private let titleView: UILabel = {
        let label = UILabel()
        label.setupDynamicBoldTextWith(policeName: "New York", size: 30, style: .title3)
        label.textColor = .colorForLabelBlackToBlue
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()

    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.layer.cornerRadius = 20
        return tableView
    }()

    private let saveButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.filled()
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 5, bottom: 10, trailing: 5)
        configuration.baseBackgroundColor = UIColor.duckBlue
        configuration.background.cornerRadius = 10
        configuration.cornerStyle = .large
        configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { titleAttributes in
            var titleAttributes = titleAttributes
            titleAttributes.font = UIFont.preferredFont(forTextStyle: .footnote)
            return titleAttributes
        }
        button.configuration = configuration
        button.setTitle("Enregistrer", for: .normal)
        button.setupShadow(radius: 1, opacity: 0.5)
        return button
    }()

// MARK: - Circle Life
    init() {
//        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .colorForGraphBackground
        titleView.text = "Selectionner une icone"

        setupViews()
        setupContraints()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(IconeSettingCell.self, forCellReuseIdentifier: IconeSettingCell.reuseIdentifier)
        tableView.rowHeight = 100

        setupButtonAction()
    }
    // MARK: - Setup
    private func setupViews() {
        [titleView, tableView, saveButton].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    private func setupContraints() {
        NSLayoutConstraint.activate([
            
            titleView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 40),
            titleView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -40),
            titleView.heightAnchor.constraint(greaterThanOrEqualToConstant: 60),

            saveButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),

            tableView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 30),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            tableView.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -20),
            tableView.heightAnchor.constraint(greaterThanOrEqualToConstant: 200),
            saveButton.widthAnchor.constraint(greaterThanOrEqualTo: tableView.widthAnchor, multiplier: 0.5)
        ])
    }

    @objc private func buttonTapped(_ sender: UITapGestureRecognizer) {
        guard let view = sender.view else { return }

        switch view.tag {
        case 0:
            setIcon(.appiconGreen)
        case 1:
            setIcon(.defaultIcon)
        case 2:
            if UIApplication.shared.supportsAlternateIcons {
              UIApplication.shared.setAlternateIconName("iconeBleue") { error in
                if let error = error {
                  print("Error changing app icon: \(error.localizedDescription)")
                } else {
                  print("App icon changed successfully.")
                }
              }
            }

        default:
            break
        }

        view.layer.borderWidth = 6
        view.layer.borderColor = UIColor.red.cgColor
    }


    // MARK: - Actions
    private func setupButtonAction() {
        saveButton.addTarget(self, action: #selector(saveData), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(holdDown), for: .touchDown)
    }

    @objc private func saveData(sender: UIButton) {
            sender.transform = .identity
            sender.layer.shadowOpacity = 0.5
//        delegate.updateInformation()
        self.dismiss(animated: true, completion: nil)
    }

    @objc func holdDown(sender: UIButton) {
        sender.transform = CGAffineTransform(scaleX: 0.97, y: 0.97)
        sender.layer.shadowOpacity = 0
    }

    // MARK: - Icon
    func setIcon(_ appIcon: NIAppIconType) {
            if UIApplication.shared.supportsAlternateIcons {
                UIApplication.shared.setAlternateIconName(appIcon.alternateIconName) { error in
                    if let error = error {
                        print("Error setting alternate icon \(appIcon.alternateIconName ): \(error.localizedDescription)")
                    }
                }
            }
        }

    // MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: IconeSettingCell.reuseIdentifier, for: indexPath) as? IconeSettingCell else {
            print("erreur de cell")
            return UITableViewCell()
        }
        var image: UIImage?
        switch indexPath.row {
        case 0:
            image = UIImage(named: "iconeNoireImage")
            cell.setupTitle(with: image!, isSelected: true)
        case 1:
            image = UIImage(named: "iconeRoseImage")
            cell.setupTitle(with: image!, isSelected: false)
        case 2:
            image = UIImage(named: "iconeRougeImage")
            cell.setupTitle(with: image!, isSelected: true)
        case 3:
            image = UIImage(named: "iconeVerteImage")
            cell.setupTitle(with: image!, isSelected: false)
        case 4:
            image = UIImage(named: "iconeBleueImage")
            cell.setupTitle(with: image!, isSelected: true)
        case 5:
            image = UIImage(named: "iconeBleueFonceImage")
            cell.setupTitle(with: image!, isSelected: false)
        default:
            image = UIImage(named: "iconeNoire")
            cell.setupTitle(with: image!, isSelected: true)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: - accessibilité
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)

    let currentCategory = traitCollection.preferredContentSizeCategory
    let previousCategory = previousTraitCollection?.preferredContentSizeCategory

    guard currentCategory != previousCategory else { return }
    let isAccessibilityCategory = currentCategory.isAccessibilityCategory

        tableView.rowHeight = isAccessibilityCategory ? 150 : 100
}
}
