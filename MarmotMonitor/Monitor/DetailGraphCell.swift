//
//  DetailGraphCell.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 21/02/2024.
//

import UIKit

class DetailGraphCell: UITableViewCell {

    let area: UIView = {
        let view = UIView()
        view.backgroundColor = .colorForPastelArea
        view.layer.cornerRadius = 20
        view.setupShadow(radius: 1, opacity: 0.5)
        return view
    }()

    let title: UILabel = {
        let label = UILabel()
        label.setupDynamicTextWith(policeName: "Symbol", size: 25, style: .body)
        label.textColor = .label
        label.textAlignment = .left
        label.numberOfLines = 2
        label.backgroundColor = .clear
        return label
    }()

    var icone = UIImageView()

    let value: UILabel = {
        let label = UILabel()
        label.setupDynamicTextWith(policeName: "Symbol", size: 25, style: .body)
        label.textColor = .label
        label.textAlignment = .left
        label.numberOfLines = 2
        label.backgroundColor = .clear
        return label
    }()

    static let reuseIdentifier = "DetailGraphCell"

    private var isAccessibilityCategory: Bool {
        let currentCategory = traitCollection.preferredContentSizeCategory
        return currentCategory.isAccessibilityCategory
    }

    // MARK: - INIT
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        self.backgroundColor = .clear
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        area.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(area)

        [title, icone, value].forEach { $0.translatesAutoresizingMaskIntoConstraints = false
            area.addSubview($0)
        }

        NSLayoutConstraint.activate([
            area.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            area.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            area.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            area.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),

            icone.centerYAnchor.constraint(equalTo: area.centerYAnchor),
            icone.leadingAnchor.constraint(equalTo: area.leadingAnchor),
            icone.widthAnchor.constraint(equalTo: icone.heightAnchor),
            icone.heightAnchor.constraint(equalTo: area.widthAnchor, multiplier: 0.15),

            value.topAnchor.constraint(equalTo: area.topAnchor, constant: 5),
            value.bottomAnchor.constraint(equalTo: area.bottomAnchor, constant: -5),
            value.trailingAnchor.constraint(equalTo: area.trailingAnchor, constant: -10),
            value.widthAnchor.constraint(equalTo: area.widthAnchor, multiplier: 0.3),

            title.topAnchor.constraint(equalTo: area.topAnchor, constant: 10),
            title.bottomAnchor.constraint(equalTo: area.bottomAnchor, constant: -5),
            title.leadingAnchor.constraint(equalTo: icone.trailingAnchor, constant: 10),
            title.trailingAnchor.constraint(equalTo: value.leadingAnchor, constant: -10)
        ])
    }

    func configure(with activityType: ShowActivityType, value: String, date: Date) {
        var iconeName = ""
        switch activityType {
        case .diaper:
            title.text = "Couche"
            iconeName = ActivityIconName.diaper.rawValue
        case .breast:
            title.text = "Allaitement"
            iconeName = ActivityIconName.meal.rawValue
        case .bottle:
            title.text = "Biberon"
            iconeName = ActivityIconName.meal.rawValue
        case .solid:
            title.text = "Repas solide"
            iconeName = ActivityIconName.meal.rawValue
        case .sleep:
            title.text = "Dodo"
            iconeName = ActivityIconName.sleep.rawValue
        }

        self.value.text = value
        let date = date.toStringWithOnlyTime()
        title.text = date + "\n" + title.text!

        icone.image = UIImage(named: iconeName)
        area.backgroundColor = UIColor.colorForIcone(imageName: iconeName).withAlphaComponent(0.2)
    }
}
