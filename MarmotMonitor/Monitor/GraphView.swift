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

typealias GraphData = (elements: [GraphActivity], style: GraphType)

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
    private var labelTexte = ["2h", "6h", "10h", "14h", "18h", "22h"]
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
    func setUpGraph(with data: GraphData) {
        guard !data.elements.isEmpty else { return }
        if data.style == .rod {
            stackViewForDay.setupShadow(radius: 1, opacity: 0.5)
        } else {
            stackViewForDay.layer.shadowOpacity = 0
        }

        setStackViewForDayCount(with: 0)

        setupStyleOfGraph(data.style, with : data.elements.count)
        cleanGraph()

        for element in data.elements {
            let (startedTime, endedTime) = calculateStartAndEndTime(for: element)
            switch data.style {
            case .ligne:
                colorGraph(type: element.type, with: element.color, startedIndex: startedTime, endIndex: endedTime)
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
            setupLigneGraph()
        }
    }

    private func setupRoundGraph() {
        setStackViewForDayCount(with: 7)

        stackViewForDay.distribution = .equalSpacing
        stackViewForDay.spacing = 0

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
        stackViewForDay.spacing = 0

        stackViewForDay.arrangedSubviews.forEach {view  in
            view.heightAnchor.constraint(greaterThanOrEqualToConstant: 30).isActive = true
        }
    }

    private func setupLigneGraph() {
        setStackViewForDayCount(with: 3)

        stackViewForDay.distribution = .fillEqually
        stackViewForDay.spacing = 2

        for stack in stackViewForDay.arrangedSubviews {
            if let stack = stack as? UIStackView {
                stack.spacing = 0
                }
            }
    }

    private func setupRoundView() {
        for stackView in stackViewForDay.arrangedSubviews {
            if let stackView = stackView as? UIStackView {
                stackView.arrangedSubviews.forEach {view  in
                    view.heightAnchor.constraint(equalTo: view.widthAnchor).isActive = true
                }
            }
        }
    }

    // MARK: - Create UI
    private func createLabelWithText(_ text: String) -> UILabel {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = text
        label.accessibilityElementsHidden = true
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
                if stack.arrangedSubviews.count > endIndex {
                    if startedIndex == endIndex {
                        let view = stack.arrangedSubviews[startedIndex]
                        view.backgroundColor = color
                    } else {
                        for index in startedIndex...endIndex {
                            let view = stack.arrangedSubviews[index]
                            view.backgroundColor = color
                        }
                    }
                }
            }
        }
    }

    private func colorGraph(type: ShowActivityType, with color: UIColor, startedIndex: Int, endIndex: Int) {
        guard startedIndex < numberOfHalfHour, endIndex <= numberOfHalfHour else {return}
        let index = getIndexLigneOfType(type)

        guard stackViewForDay.arrangedSubviews.count - 1 >= index else {return}
            if let stack = stackViewForDay.arrangedSubviews[index] as? UIStackView {
                if stack.arrangedSubviews.count > endIndex {
                    if startedIndex == endIndex {
                        let view = stack.arrangedSubviews[startedIndex]
                        view.backgroundColor = color
                    } else {
                        for index in startedIndex...endIndex {
                            let view = stack.arrangedSubviews[index]
                            view.backgroundColor = color
                            view.layer.cornerRadius = 0
                            if index == startedIndex {
                                view.layer.cornerRadius = 2
                                view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
                            } else if index == endIndex {
                                view.layer.cornerRadius = 2
                                view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
                            }
                        }
                    }
                }
            }
    }

    private func getIndexLigneOfType( _ type: ShowActivityType) -> Int {
        switch type {
        case .bottle, .breast, .solid:
            return 0
        case .sleep:
            return 1
        case .diaper:
            return 2
        }
    }

    private func setTimeBaseLigne() {
        if stackViewForDay.arrangedSubviews.count > 3 {
            if let stackView = stackViewForDay.arrangedSubviews[3] as? UIStackView {
                for (index, view) in stackView.arrangedSubviews.enumerated() where index % 2 == 0 {
                    view.backgroundColor = .colorForLabelBlackToBlue
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
        let duration = ceil(Double(element.duration.inMinutes() / 30))
        let end = startedTime + Int(duration)
        let endedTime = min(end, numberOfHalfHour)

        return (startedTime, endedTime)
    }
}
