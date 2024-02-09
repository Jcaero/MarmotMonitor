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

    private let areaStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fillEqually
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Properties
 
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
    typealias GraphData = (elements: [GraphActivity], style: GraphType)
    func setUpGraph(with data: GraphData) {
        guard !data.elements.isEmpty else { return }
        setStackViewForDayCount(with: 0)

        setupStyleOfGraph(data.style, with : data.elements.count)
        cleanGraph()

        for (index, element) in data.elements.enumerated() {
            let (startedTime, endedTime) = calculateStartAndEndTime(for: element)
            switch data.style {
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
        setStackViewForDayCount(with: 1)

        setupAbscissaAxisLegend()
        addStackViewsToSuperview()

        setupContrainte()
    }
    private func setStackViewForDayCount(with numberOfStackView: Int) {

        while stackViewForDay.arrangedSubviews.count > numberOfStackView {
            stackViewForDay.removeArrangedSubview(stackViewForDay.arrangedSubviews.last!)
        }

        while stackViewForDay.arrangedSubviews.count < numberOfStackView {
            let stackView = createStackView(axis: .horizontal, distribution: .fillEqually, spacing: 2)
            addHalfHourView(in: stackView)
            stackViewForDay.addArrangedSubview(stackView)
        }
    }

    private func setupAbscissaAxisLegend() {
        labelTexte.forEach { text in
            let label = createLabelWithText(text)
            stackViewLabelHour.addArrangedSubview(label)
        }
    }

    private func addStackViewsToSuperview() {
        addSubview(areaStackView)
        areaStackView.addArrangedSubview(stackViewForDay)
        areaStackView.addArrangedSubview(stackViewLabelHour)

    }

    private func setupContrainte() {
        NSLayoutConstraint.activate([
            areaStackView.topAnchor.constraint(equalTo: topAnchor),
            areaStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            areaStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            areaStackView.heightAnchor.constraint(greaterThanOrEqualToConstant: 60),
            areaStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    private func addHalfHourView(in stackView: UIStackView) {
        for _ in 1...numberOfHalfHour {
            let view = UIView()
            view.backgroundColor = .systemGray6
            view.layer.cornerRadius = 3
            view.clipsToBounds = true
            view.translatesAutoresizingMaskIntoConstraints = false
            stackView.addArrangedSubview(view)
        }
    }

    // MARK: - Graph Style
    private func setupStyleOfGraph(_ style: GraphType, with numberOfLine: Int) {
        let style = style
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
        setStackViewForDayCount(with: 7)

        for stackView in stackViewForDay.arrangedSubviews {
            if let stackView = stackView as? UIStackView {
                stackView.arrangedSubviews.forEach {view  in
                    view.heightAnchor.constraint(equalTo: view.widthAnchor).isActive = true
                }
            }
        }
    }

    private func setupRodGraph() {
        setStackViewForDayCount(with: 1)
        stackViewForDay.distribution = .equalSpacing
        stackViewForDay.arrangedSubviews.forEach {view  in
            view.heightAnchor.constraint(greaterThanOrEqualToConstant: 30).isActive = true
        }
    }

    private func setupLigneGraph(with numberOfLigne: Int) {
        stackViewForDay.distribution = .fillEqually
//        setStackViewForDayCount(numberOfStackView: numberOfLigne-1)

//        while stackViewForDay.arrangedSubviews.count > 1 {
//            stackViewForDay.removeArrangedSubview(stackViewForDay.arrangedSubviews.last!)
//        }

    }

    // MARK: - Create UI
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
        for stack in stackViewForDay.arrangedSubviews {
            if let stack = stack as? UIStackView {
                if stack.arrangedSubviews.count > endIndex-1 {
                    if startedIndex == endIndex {
                        let view = stack.arrangedSubviews[startedIndex]
                        view.backgroundColor = color
                    } else {
                        for index in startedIndex...endIndex-1 {
                            let view = stack.arrangedSubviews[index]
                            view.backgroundColor = color
                        }
                    }
                }
            }
        }
    }

    private func colorGraph(number: Int, with color: UIColor, startedIndex: Int, endIndex: Int) {
//        guard startedIndex < numberOfHalfHour, endIndex <= numberOfHalfHour else {return}
//        guard stackViews.count > number else { return }
//        let stackview = stackViews[number]
//        if stackview.arrangedSubviews.count > endIndex-1 {
//            if startedIndex == endIndex {
//                let view = stackview.arrangedSubviews[startedIndex]
//                view.backgroundColor = color
//            } else {
//                for index in startedIndex...endIndex-1 {
//                    let view = stackview.arrangedSubviews[index]
//                    view.backgroundColor = color
//                }
//            }
//        }
    }

    private func setTimeBaseLigne() {
        if stackViewForDay.arrangedSubviews.count > 3 {
            if let stackView = stackViewForDay.arrangedSubviews[3] as? UIStackView {
                for (index, view) in stackView.arrangedSubviews.enumerated() where index % 2 == 0 {
                    view.backgroundColor = .black
                }
            }
        }
    }

    private func cleanGraph() {
        for stack in stackViewForDay.arrangedSubviews {
            if let stack = stack as? UIStackView {
                stack.arrangedSubviews.forEach {view  in
                    view.backgroundColor = .systemGray6
                }
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
