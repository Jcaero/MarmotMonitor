//
//  monitorCell.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 23/01/2024.
//

import UIKit

typealias DataCell = (date: Date, elementsToLegend: [String:String])

/// MonitorCell is the cell for the monitor view
/// It display the data of the monitor in graph
/// It display date, graph and summary of the day
/// configure with func setUp(with data: DataCell, graphData: GraphData)
class MonitorCell: UITableViewCell {
    let date: UILabel = {
        let label = UILabel()
        label.setupDynamicTextWith(policeName: "Symbol", size: 25, style: .body)
        label.textColor = .label
        label.textAlignment = .left
        label.numberOfLines = 2
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

    let graph: GraphView = {
        let graph = GraphView()
        return graph
    }()

    private let stackViewActivities: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .equalCentering
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let topInformationStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .center
        view.distribution = .fill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let editingImage: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.tintColor = .black
        view.image = UIImage(systemName: "pencil")
        view.setAccessibility(with: .button, label: "modifier", hint: "")
        return view
    }()

    // MARK: - Properties
    static let reuseIdentifier = "MonitorCell"
    private var activities: [GraphActivity] = []

    private var isAccessibilityCategory: Bool = false

    // MARK: - INIT
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        self.backgroundColor = .clear

        let currentCategory = traitCollection.preferredContentSizeCategory
        isAccessibilityCategory = currentCategory.isAccessibilityCategory
        setupStackViewAxis()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - setup
    private func setupUI() {
        area.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(area)

        [graph, stackViewActivities, topInformationStackView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            area.addSubview($0)
        }

        [date, editingImage].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            topInformationStackView.addArrangedSubview($0)
        }

        NSLayoutConstraint.activate([
            area.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            area.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 2),
            area.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -2),
            area.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),

            topInformationStackView.topAnchor.constraint(equalTo: area.topAnchor, constant: 10),
            topInformationStackView.leadingAnchor.constraint(equalTo: area.leadingAnchor, constant: 10),
            topInformationStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            editingImage.heightAnchor.constraint(equalTo: editingImage.widthAnchor),

            graph.topAnchor.constraint(equalTo: topInformationStackView.bottomAnchor, constant: 10),
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

    private func setupStackViewAxis() {
        stackViewActivities.axis = isAccessibilityCategory ? .vertical : .horizontal
    }

    // MARK: - Configure
    func setUp(with data: DataCell, graphData: GraphData) {

        self.date.text = data.date.toStringWithDayMonthYear()
        date.setAccessibility(with: .header, label: "jour de la synthèse", hint: data.date.toStringWithDayMonthYear())

        updateLegend(with: data.elementsToLegend)

        graph.setUpGraph(with: graphData)

        setupEditingImage()
    }

    private func updateLegend(with elements: [String:String]) {
        stackViewActivities.arrangedSubviews.forEach { $0.removeFromSuperview() }
        let list = elements.sorted(by: { $0.key > $1.key })

        list.forEach { element in
            if element.value != "\n0 fois" {
                var information = isAccessibilityCategory ? element.key + ": " : ""
                information += element.value

                let data = LegendGraphData(information: information, imageName: element.key)
                let view = LegendGraphView(data: data)
                view.translatesAutoresizingMaskIntoConstraints = false
                stackViewActivities.addArrangedSubview(view)
            }
        }
    }

    private func setupEditingImage() {
        let multiplier = isAccessibilityCategory ? 0.7 : 0.9
        editingImage.heightAnchor.constraint(equalTo: date.heightAnchor, multiplier: multiplier).isActive = true
    }
}
