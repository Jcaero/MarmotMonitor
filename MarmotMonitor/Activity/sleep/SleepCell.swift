//
//  SleepCell.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 18/12/2023.
//

import UIKit

class SleepCell: UITableViewCell {

    // MARK: - liste of UI elements
    let title: UILabel = {
        let label = UILabel()
        label.setupDynamicTextWith(policeName: "Symbol", size: 15, style: .body)
        label.text = "0"
        label.textColor = .label
        label.textAlignment = .left
        label.numberOfLines = 0
        label.backgroundColor = .clear
        label.setAccessibility(with: .header, label: "poids de l'ingredient", hint: "")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let dateLabel: UILabel = {
        let label = UILabel()
        label.setupDynamicTextWith(policeName: "Symbol", size: 25, style: .body)
        label.text = "Pas encore de date"
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = 0
        label.setAccessibility(with: .header, label: "", hint: "")
        return label
    }()

    let statusButton: UIButton =  {
        var configuration = UIButton.Configuration.filled()
        configuration.image = UIImage(systemName: "chevron.right")!
            .applyingSymbolConfiguration(.init(pointSize: 30))
        configuration.cornerStyle = .capsule
        configuration.baseBackgroundColor = .duckBlue
        configuration.baseForegroundColor = .label
        configuration.contentInsets = .zero
        let button = UIButton(configuration: configuration)
        button.setAccessibility(with: .button, label: "", hint: "ouvrir le picker")
        return button
    }()

    let durationLabel: UILabel = {
        let label = UILabel()
        label.setupDynamicTextWith(policeName: "Symbol", size: 15, style: .body)
        label.text = ""
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = 1
        label.setAccessibility(with: .header, label: "", hint: "")
        return label
    }()

    // MARK: - Properties
    static let reuseIdentifier = "SleepCell"

    // MARK: - cycle life
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupContraint()
        self.backgroundColor = .clear
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - UI
    private func setupUI() {
        [title, dateLabel, durationLabel, statusButton].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    private func setupContraint() {
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            title.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
            title.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10)
        ])

        NSLayoutConstraint.activate([
            statusButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            statusButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
            statusButton.heightAnchor.constraint(equalTo: statusButton.widthAnchor),
            statusButton.heightAnchor.constraint(equalTo: dateLabel.heightAnchor)
        ])

        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 10),
            dateLabel.rightAnchor.constraint(equalTo: statusButton.leftAnchor, constant: -10),
            dateLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }

    private func setupButton() {
        let setImage = UIImage(systemName: "chevron.right")!
            .applyingSymbolConfiguration(.init(pointSize: 15))
        let cancelImage = UIImage(systemName: "x.circle")!
            .applyingSymbolConfiguration(.init(pointSize: 15))
        let image = self.dateLabel.text == "Pas encore de date" ? setImage : cancelImage
        statusButton.setImage(image, for: .normal)
    }

    // MARK: - Setup cell
    func setupCell(with title: String, date: String) {
        self.title.text = title
        self.dateLabel.text = date

        setupButton()
    }
}
