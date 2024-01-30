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

    let area: UIView = {
        let view = UIView()
        view.backgroundColor = .colorForPastelArea
        view.layer.cornerRadius = 20
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = .zero
        return view
    }()

    let graph = GraphView()

    private let stackViewActivities: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .equalCentering
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Properties
    static let reuseIdentifier = "MonitorCell"
    private var activities: [GraphActivity] = []

    typealias DataCell = (date: Date, elementsToLegend: [String:String])
    typealias GraphData = (elements: [GraphActivity], style: GraphType)

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

        [date, graph, stackViewActivities].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            area.addSubview($0)
        }

        NSLayoutConstraint.activate([
            area.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            area.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 2),
            area.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -2),
            area.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),

            date.topAnchor.constraint(equalTo: area.topAnchor, constant: 10),
            date.leadingAnchor.constraint(equalTo: area.leadingAnchor, constant: 10),
            date.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),

            graph.topAnchor.constraint(equalTo: date.bottomAnchor, constant: 10),
            graph.leadingAnchor.constraint(equalTo: area.leadingAnchor, constant: 10),
            graph.trailingAnchor.constraint(equalTo: area.trailingAnchor, constant: -10),
            graph.heightAnchor.constraint(greaterThanOrEqualToConstant: 30),

            stackViewActivities.topAnchor.constraint(equalTo: graph.bottomAnchor, constant: 4),
            stackViewActivities.leadingAnchor.constraint(equalTo: area.leadingAnchor, constant: 10),
            stackViewActivities.trailingAnchor.constraint(equalTo: area.trailingAnchor, constant: -10),
            stackViewActivities.heightAnchor.constraint(greaterThanOrEqualToConstant: 10),
            stackViewActivities.bottomAnchor.constraint(equalTo: area.bottomAnchor, constant: -5)
        ])
    }

    // MARK: - Configure
    func setUp(with data: DataCell, graphData: GraphData) {

        self.date.text = data.date.toStringWithDayMonthYear()
        updateLegend(with: data.elementsToLegend)

        graph.setUpGraph(with: graphData)
    }

    private func updateLegend(with elements: [String:String]) {
        stackViewActivities.arrangedSubviews.forEach { $0.removeFromSuperview() }
        let list = elements.sorted(by: { $0.key > $1.key })

        list.forEach { element in
            if element.value != "\n0 fois" {
                let view = LegendGraphView(information: element.value, imageName: element.key)
                view.translatesAutoresizingMaskIntoConstraints = false
                stackViewActivities.addArrangedSubview(view)
            }
        }
    }
}
