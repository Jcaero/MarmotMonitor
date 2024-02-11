//
//  IconeSettingCell.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 10/02/2024.
//

import UIKit

class IconeSettingCell: UITableViewCell {
    private let icone: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .duckBlue
        view.clipsToBounds = true
        return view
    }()

    private let checkmark: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "checkmark")
        view.tintColor = .duckBlue
        view.clipsToBounds = true
        return view
    }()

    // MARK: - Properties
    static let reuseIdentifier = "IconeSettingCell"

    // MARK: - INIT
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        layer.cornerRadius = 20
        setupShadow(radius: 1, opacity: 0.5)

        setupViews()
        setupContraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        [icone, checkmark].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    private func setupContraints() {
        NSLayoutConstraint.activate([
            icone.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            icone.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            icone.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            icone.heightAnchor.constraint(equalTo: icone.widthAnchor),

            checkmark.centerYAnchor.constraint(equalTo: centerYAnchor),
            checkmark.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            checkmark.heightAnchor.constraint(equalTo: checkmark.widthAnchor),
            checkmark.heightAnchor.constraint(equalToConstant: frame.height * 0.5)
        ])
    }

    func setupTitle(with icone: UIImage, isSelected: Bool) {
        self.icone.image = icone
        if isSelected {
            checkmark.isHidden = false
            backgroundColor = .duckBlue.withAlphaComponent(0.2)
        } else {
            checkmark.isHidden = true
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        icone.layer.cornerRadius = icone.frame.height / 8
        layoutIfNeeded()
    }
}
