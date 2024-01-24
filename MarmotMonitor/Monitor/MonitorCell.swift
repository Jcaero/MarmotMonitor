//
//  monitorCell.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 23/01/2024.
//

import UIKit

class MonitorCell: UITableViewCell {
    let date: UILabel = {
        let label = UILabel()
        label.setupDynamicTextWith(policeName: "Symbol", size: 25, style: .body)
        label.textColor = .label
        label.textAlignment = .left
        label.numberOfLines = 0
        label.backgroundColor = .clear
        label.setAccessibility(with: .header, label: "jour de la synthese", hint: "")
        return label
    }()

    let stackViewAll: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fillProportionally
        return view
    }()

    let stackViewHour: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fillEqually
        return view
    }()

    // MARK: - Properties
    static let reuseIdentifier = "MonitorCell"

    private var stackViews: [UIStackView] = []
    private var numberOfStackViews = 7
    private var labelTexte = ["2", "6", "10", "14", "18", "22"]

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
        [date, stackViewAll].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        for _ in 1...numberOfStackViews {
            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.distribution = .fillEqually
            stackView.spacing = 1
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackViews.append(stackView)
        }

        for index in 1...6 {
            let label = UILabel()
            label.setupDynamicTextWith(policeName: "Symbol", size: 15, style: .body)
            label.textColor = .label
            label.textAlignment = .center
            label.numberOfLines = 0
            label.text = labelTexte[index - 1]
            label.translatesAutoresizingMaskIntoConstraints = false
            label.heightAnchor.constraint(equalToConstant: 20).isActive = true
            stackViewHour.addArrangedSubview(label)
        }

        contentView.addSubview(date)
        contentView.addSubview(stackViewAll)
        stackViews.forEach {
            stackViewAll.addArrangedSubview($0)
        }
        stackViewAll.addArrangedSubview(stackViewHour)

        NSLayoutConstraint.activate([
            date.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            date.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            date.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),

            stackViewAll.topAnchor.constraint(equalTo: date.bottomAnchor, constant: 10),
            stackViewAll.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            stackViewAll.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            stackViewAll.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
        setupStackView()
    }

    private func setupStackView () {
        stackViews.forEach {
            for _ in 1...48 {
                let view = UIView()
                view.backgroundColor = .systemGray6
                view.layer.cornerRadius = 3
                view.layer.borderWidth = 1
                view.layer.borderColor = UIColor.systemGray3.cgColor
                view.clipsToBounds = true
                $0.addArrangedSubview(view)
                view.translatesAutoresizingMaskIntoConstraints = false
                view.heightAnchor.constraint(equalTo: view.widthAnchor).isActive = true
            }
        }
    }

    // MARK: - Configure
    func setupCell(with date: Date, elements: [ShowActivity]) {
        self.date.text = date.toStringWithDayMonthYear()

        stackViews.forEach {
            if $0.arrangedSubviews.count > 24 {
                for index in 11...23 {
                    let view = $0.arrangedSubviews[index]
                    view.backgroundColor = .red
                }
            }
        }

        for (index, view) in stackViews[3].arrangedSubviews.enumerated() where index % 2 == 0 {
            view.backgroundColor = .black
        }
    }
}
