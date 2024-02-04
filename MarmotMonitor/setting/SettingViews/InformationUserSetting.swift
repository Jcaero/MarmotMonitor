//
//  InformationUserSetting.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 04/02/2024.
//

import UIKit

class InformationUserSetting: UITableViewCell {
    let title: UILabel = {
        let label = UILabel()
        label.setupDynamicBoldTextWith(policeName: "Symbol", size: 20, style: .body)
        label.textColor = .colorForLabelBlackToBlue
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()

    let subtitle: UILabel = {
        let label = UILabel()
        label.setupDynamicBoldTextWith(policeName: "Symbol", size: 17, style: .body)
        label.textColor = .colorForLabelBlackToBlue
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()

    let modifierButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.filled()
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        configuration.baseBackgroundColor = UIColor.colorForDuckBlueToWhite
        configuration.background.cornerRadius = 10
        configuration.cornerStyle = .large
        configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { titleAttributes in
            var titleAttributes = titleAttributes
            titleAttributes.font = UIFont.preferredFont(forTextStyle: .footnote)
            return titleAttributes
        }
        button.configuration = configuration
        button.setTitle("Modifier", for: .normal)
        button.setupShadow(radius: 1, opacity: 0.5)
        return button
    }()

    // MARK: - Properties
    static let reuseIdentifier = "MonitorCell"

    // MARK: - INIT
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        self.backgroundColor = .clear
        setupContraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        [title, subtitle, modifierButton].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    private func setupContraints() {
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            title.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),

            modifierButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -5),
            modifierButton.leftAnchor.constraint(greaterThanOrEqualTo: title.rightAnchor, constant: 2),
            modifierButton.centerYAnchor.constraint(equalTo: centerYAnchor),

            subtitle.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 2),
            subtitle.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            subtitle.rightAnchor.constraint(equalTo: title.rightAnchor, constant: -10),
            subtitle.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)

        ])
    }

    func setupTitle(with title: String, subtitle: String) {
        self.title.text = title
        self.subtitle.text = subtitle

    }
}
