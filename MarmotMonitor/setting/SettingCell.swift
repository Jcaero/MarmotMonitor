//
//  GraphTypeSettingCell.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 07/02/2024.
//

import UIKit
/// This class is a cell for the setting view controller
/// It display setting to modify the app :
///  - icone: icone of the setting
///  - nameTitle: title of the setting
///  - information: information of the setting actually value

class SettingCell: UITableViewCell {
    private let icone: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .clearToWhite
        view.tintColor = .black
        view.clipsToBounds = true
        return view
    }()

    private let nameTitle: UILabel = {
        let label = UILabel()
        label.setupDynamicTextWith(policeName: "Symbol", size: 20, style: .body)
        label.textColor = .colorForDuckBlueToWhite
        label.textAlignment = .left
        return label
    }()

    private let information: UILabel = {
        let label = UILabel()
        label.setupDynamicTextWith(policeName: "Symbol", size: 20, style: .body)
        label.textColor = .colorForDuckBlueToWhite
        label.textAlignment = .right
        return label
    }()

    private let areaStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .center
        view.spacing = 5
        view.distribution = .fillProportionally
        return view
    }()

    // MARK: - Properties
    static let reuseIdentifier = "SettingCell"

    private var iconeWidth: NSLayoutConstraint?

    private var isAccessibility: Bool {
        return traitCollection.preferredContentSizeCategory.isAccessibilityCategory
    }

    // MARK: - INIT
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear

        setupViews()
        setupContraints()

        information.isHidden = isAccessibility
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup
    private func setupViews() {
        [icone, areaStackView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }

        [nameTitle, information].forEach {
            areaStackView.addArrangedSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    private func setupContraints() {
        iconeWidth = icone.widthAnchor.constraint(equalToConstant: frame.width / 10)
        NSLayoutConstraint.activate([
            heightAnchor.constraint(greaterThanOrEqualToConstant: 10),
            iconeWidth!,
            icone.heightAnchor.constraint(equalTo: icone.widthAnchor),
            icone.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            icone.centerYAnchor.constraint(equalTo: centerYAnchor),

            information.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.2),
            areaStackView.leadingAnchor.constraint(equalTo: icone.trailingAnchor, constant: 10),
            areaStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            areaStackView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            areaStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),

            areaStackView.heightAnchor.constraint(equalTo: nameTitle.heightAnchor)
        ])
    }

    /// Setup the cell with a title, an information and an icone
    /// - Parameters:
    ///  - title: the title of the cell
    ///  - information: the status of the information
    ///  - icone: the icone
    func setupTitle(with title: String, information: String, icone: UIImage) {
        let titleAccessibility = title + " " + information + " >"

        self.nameTitle.text = isAccessibility ? titleAccessibility : title
        self.information.text = information + " >"
        self.icone.image = icone

        iconeWidth?.constant = isAccessibility ? 0 : frame.width / 10
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        icone.layer.cornerRadius = icone.frame.height / 8
        layoutIfNeeded()
    }
}
