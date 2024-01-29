//
//  GraphView.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 24/01/2024.
//

import UIKit

/// View for the graph
/// The graph is composed of 1 stackViewAll represents a day
/// Each stackViewAll is composed of 48 stackViewHourly representing the half hours of the day
/// You can choose the type of graph you want to display
/// - round: display a round graph
/// - rod: display a rod graph
/// - ligne: display a line per element
///  For the round and rod graph, put the element in decreasing importance
///
///  func setupGraphView(with elements: [ShowActivity], style: GraphType)
///  Parameters:
///  - elements: array of ShowActivity
///  - style: type of graph

class GraphView: UIView {
    private let stackViewForDay: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .equalSpacing
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let stackViewLabelHour: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.spacing = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Properties
    private var stackViews: [UIStackView] = []
    private var labelTexte = ["2", "6", "10", "14", "18", "22"]
    private let numberOfHalfHour = 48

    // MARK: - INIT
    init() {
        super.init(frame: .zero)
        self.backgroundColor = .clear
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configure
    func setupGraphView(with elements: [GraphActivity], style: GraphType) {
        guard !elements.isEmpty else { return }

        setupStyleOfGraph(style, with : elements.count)
        cleanGraph()

        for (index, element) in elements.enumerated() {
            let (startedTime, endedTime) = calculateStartAndEndTime(for: element)
            switch style {
            case .ligne:
                colorGraph(number: index, with: element.color, startedIndex: startedTime, endIndex: endedTime)
            default:
                colorGraph(with: element.color, startedIndex: startedTime, endIndex: endedTime)
            }
        }

        setTimeBaseLigne()
    }

    // MARK: - Setup UI
    private func setupUI() {
        setupStackViews()
        setupAbscissaAxisLegend()
        addStackViewsToSuperview()
        setupHourlyView()
        setupContrainte()
    }

    private func setupStackViews() {
        for _ in 1...7 {
            let stackView = createStackView(axis: .horizontal, distribution: .fillEqually, spacing: 2)
            stackViews.append(stackView)
        }
    }

    private func setupAbscissaAxisLegend() {
        labelTexte.forEach { text in
            let label = createLabelWithText(text)
            stackViewLabelHour.addArrangedSubview(label)
        }
    }

    private func addStackViewsToSuperview() {
        addSubview(stackViewForDay)
        addSubview(stackViewLabelHour)

        guard !stackViews.isEmpty else { return }
        stackViewForDay.addArrangedSubview(stackViews.first!)
    }

    private func setupContrainte() {
        NSLayoutConstraint.activate([
            stackViewLabelHour.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackViewLabelHour.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackViewLabelHour.heightAnchor.constraint(equalToConstant: 30),
            stackViewLabelHour.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        NSLayoutConstraint.activate([
            stackViewForDay.bottomAnchor.constraint(equalTo: stackViewLabelHour.topAnchor),
            stackViewForDay.topAnchor.constraint(equalTo: topAnchor),
            stackViewForDay.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackViewForDay.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackViewForDay.heightAnchor.constraint(greaterThanOrEqualToConstant: 30)
        ])
    }

    private func setupHourlyView () {
        stackViews.forEach {
            for _ in 1...numberOfHalfHour {
                let view = UIView()
                view.backgroundColor = .systemGray6
                view.layer.cornerRadius = 3
                view.clipsToBounds = true
                $0.addArrangedSubview(view)
                view.translatesAutoresizingMaskIntoConstraints = false
            }
        }
    }

    private func setupStyleOfGraph(_ style: GraphType, with numberOfLine: Int) {
        switch style {
        case .round:
            setupRoundGraph()
        case .rod:
            setupRodGraph()
        case .ligne:
            setupLigneGraph(with: numberOfLine)
        }
    }

    private func setupRoundGraph() {
        stackViewForDay.distribution = .equalSpacing
        stackViews.forEach {
            $0.arrangedSubviews.forEach {view  in
                view.heightAnchor.constraint(equalTo: view.widthAnchor).isActive = true
            }
        }

        for index in 1..<stackViews.count-1 {
            stackViewForDay.addArrangedSubview(stackViews[index])
        }
    }

    private func setupRodGraph() {
        stackViewForDay.distribution = .equalSpacing
        stackViews.forEach {
            $0.arrangedSubviews.forEach {view  in
                view.heightAnchor.constraint(greaterThanOrEqualToConstant: 30).isActive = true
            }
        }
    }

    private func setupLigneGraph(with numberOfLigne: Int) {
        stackViewForDay.distribution = .fillEqually

        guard numberOfLigne > 1, stackViews.count > numberOfLigne else { return }
        for index in 1..<numberOfLigne {
            stackViewForDay.addArrangedSubview(stackViews[index])
        }
    }

    private func createLabelWithText(_ text: String) -> UILabel {
        let label = UILabel()
        label.setupDynamicTextWith(policeName: "Symbol", size: 15, style: .body)
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = text
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }

    private func createStackView(axis: NSLayoutConstraint.Axis, distribution: UIStackView.Distribution, spacing: CGFloat) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = axis
        stackView.distribution = distribution
        stackView.spacing = spacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }

    // MARK: - Color graph
    private func colorGraph(with color: UIColor, startedIndex: Int, endIndex: Int) {
        guard startedIndex < numberOfHalfHour, endIndex <= numberOfHalfHour else {return}
        stackViews.forEach {
            if $0.arrangedSubviews.count > endIndex-1 {
                if startedIndex == endIndex {
                    let view = $0.arrangedSubviews[startedIndex]
                    view.backgroundColor = color
                } else {
                    for index in startedIndex...endIndex-1 {
                        let view = $0.arrangedSubviews[index]
                        view.backgroundColor = color
                    }
                }
            }
        }
    }

    private func colorGraph(number: Int, with color: UIColor, startedIndex: Int, endIndex: Int) {
        guard startedIndex < numberOfHalfHour, endIndex <= numberOfHalfHour else {return}
        guard stackViews.count >= number - 1 else  { return }
        let stackview = stackViews[number]
        if stackview.arrangedSubviews.count > endIndex-1 {
            if startedIndex == endIndex {
                let view = stackview.arrangedSubviews[startedIndex]
                view.backgroundColor = color
            } else {
                for index in startedIndex...endIndex-1 {
                    let view = stackview.arrangedSubviews[index]
                    view.backgroundColor = color
                }
            }
        }
    }

    private func setTimeBaseLigne() {
        if stackViews.indices.contains(3) {
            let stackView = stackViews[3]
            for (index, view) in stackView.arrangedSubviews.enumerated() where index % 2 == 0 {
                view.backgroundColor = .black
            }
        }
    }

    private func cleanGraph() {
        stackViews.forEach {
            $0.arrangedSubviews.forEach {view  in
                view.backgroundColor = .systemGray5
            }
        }
    }

    private func calculateStartAndEndTime( for element: GraphActivity) -> (start: Int, end: Int) {
        let startedTime = element.timeStart.inMinute() / 30

        let end = startedTime + (element.duration.inMinutes() / 30)
        let endedTime = min(end, numberOfHalfHour)

        return (startedTime, endedTime)
    }
}
