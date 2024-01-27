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

    let graph = GraphView(style: .rod)

    private let stackViewActivities: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .equalSpacing
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Properties
    static let reuseIdentifier = "MonitorCell"
    private var activities: [GraphActivity] = []

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
        [date, graph, stackViewActivities].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }

        NSLayoutConstraint.activate([
            date.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            date.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            date.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),

            graph.topAnchor.constraint(equalTo: date.bottomAnchor, constant: 10),
            graph.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            graph.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            graph.heightAnchor.constraint(greaterThanOrEqualToConstant: 30),

            stackViewActivities.topAnchor.constraint(equalTo: graph.bottomAnchor, constant: 10),
            stackViewActivities.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            stackViewActivities.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            stackViewActivities.heightAnchor.constraint(greaterThanOrEqualToConstant: 30),
            stackViewActivities.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }

    // MARK: - Configure
    func setupCell(with date: Date, elementsToGraph: [GraphActivity], style: GraphType, elementsToLegend: [String:String]) {
        activities = elementsToGraph
        self.date.text = date.toStringWithDayMonthYear()
        graph.setupGraphView(with: elementsToGraph)

//        updateLegend(with: elementsToLegend)
    }

    private func updateLegend(with elements: [String:String]) {
        elements.forEach { element in
            let view = LegendGraphView(information: element.value, imageName: element.key)
            view.translatesAutoresizingMaskIntoConstraints = false
            stackViewActivities.addArrangedSubview(view)
        }
    }
}
