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

    let graph = GraphView()

    // MARK: - Properties
    static let reuseIdentifier = "MonitorCell"

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
        date.translatesAutoresizingMaskIntoConstraints = false
        graph.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(date)
        contentView.addSubview(graph)

        NSLayoutConstraint.activate([
            date.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            date.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            date.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),

            graph.topAnchor.constraint(equalTo: date.bottomAnchor, constant: 10),
            graph.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            graph.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
//            graph.heightAnchor.constraint(equalToConstant: 80),
            graph.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }

    // MARK: - Configure
    func setupCell(with date: Date, elements: [ShowActivity], style: GraphType) {
        // test
        let date1 = "07/11/2023 15:30".toDateWithTime()!
        let date2 = "07/11/2023 07:30".toDateWithTime()!
        let exemple: [ShowActivity] = [ ShowActivity(color: .red, timeStart: date1, duration: 60), ShowActivity(color: .blue, timeStart: date2, duration: 240) ]

        self.date.text = date.toStringWithDayMonthYear()
        graph.setupGraphView(with: exemple, style: style)
    }
}
