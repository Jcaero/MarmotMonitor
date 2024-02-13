//
//  GraphTypeSettingCell.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 07/02/2024.
//

import UIKit

class SettingCell: UITableViewCell {
    private let icone: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .pastelPink
        view.tintColor = .black
        view.clipsToBounds = true
        return view
    }()

    private let nameTitle: UILabel = {
        let label = UILabel()
        label.setupDynamicTextWith(policeName: "Symbol", size: 20, style: .body)
        label.textColor = .colorForDuckBlueToWhite
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()

    private let information: UILabel = {
        let label = UILabel()
        label.setupDynamicTextWith(policeName: "Symbol", size: 20, style: .body)
        label.textColor = .colorForDuckBlueToWhite
        label.textAlignment = .right
        label.numberOfLines = 0
        return label
    }()

    private let areaStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .equalSpacing
        return view
    }()

    // MARK: - Properties
    static let reuseIdentifier = "SettingCell"

    private var nameLeadingConstraint: NSLayoutConstraint?
    private var nameLeadingAccesibilityConstraint: NSLayoutConstraint?
    private var nameTrailingConstraint: NSLayoutConstraint?
    private var nameTrailingAccessibilityConstraint: NSLayoutConstraint?

    // MARK: - INIT
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear

        setupViews()
        setupContraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        [nameTitle, icone, information].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    private func setupContraints() {
        NSLayoutConstraint.activate([
            heightAnchor.constraint(greaterThanOrEqualToConstant: 60),
            icone.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            icone.heightAnchor.constraint(equalToConstant: frame.height * 0.65),
            icone.heightAnchor.constraint(equalTo: icone.widthAnchor),
            icone.centerYAnchor.constraint(equalTo: centerYAnchor),

            information.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            information.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            information.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            information.widthAnchor.constraint(equalToConstant: 100),

            nameTitle.leadingAnchor.constraint(equalTo: icone.trailingAnchor, constant: 10),
            nameTitle.trailingAnchor.constraint(equalTo: information.leadingAnchor, constant: -15),
            nameTitle.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            nameTitle.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }

    func setupTitle(with title: String, information: String, icone: UIImage) {
        self.nameTitle.text = title
        self.information.text = information + " >"
        self.icone.image = icone
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        icone.layer.cornerRadius = icone.frame.height / 8
        layoutIfNeeded()
    }
}
