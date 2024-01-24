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

    private var styleOfGraph: GraphType = .round
    private var numberOfElements: Int?
    private var numberOfStackViews: Int {
        switch styleOfGraph {
        case .round:
            return 7
        case .rod:
            return 1
        case .ligne:
            return numberOfElements ?? 5
        }
    }

    // MARK: - INIT
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configure
    func setupGraphView(with elements: [ShowActivity], style: GraphType) {
        guard !elements.isEmpty else { return }
        styleOfGraph = style
        numberOfElements = elements.count

        setupUI()

        elements.enumerated().forEach { index, element in
            let time = element.timeStart.getHourAndMin()
            guard let hour = time.hour else { return}
            var startedTime = hour * 2

            if let min = time.min, min >= 30 {
                startedTime += 1
            }

            let duration = element.duration / 30
            var endedTime = (startedTime + duration) - 1
            if endedTime > 48 {
                endedTime = 48
            }

            switch  styleOfGraph {
            case .round, .rod:
                colorGraph(with: element.color, startedIndex: startedTime, endIndex: endedTime)
            case .ligne:
                colorGraphNumber(index, with: element.color, startedIndex: startedTime, endIndex: endedTime)
            }
        }
        setTimeBaseLigne()
    }

    // MARK: - Setup UI
    private func setupUI() {
        setupStackViews()
        setupStackViewHourLabels()
        addStackViewsToSuperview()
        setupHourlyViewInStackView()
        setupContrainte()
    }

    private func setupStackViews() {
        for _ in 1...numberOfStackViews {
            let stackView = createStackView(axis: .horizontal, distribution: .fillEqually, spacing: 2)
            stackViews.append(stackView)
        }
    }

    private func setupStackViewHourLabels() {
        labelTexte.forEach { text in
            let label = createLabelWithText(text)
            stackViewLabelHour.addArrangedSubview(label)
        }
    }

    private func addStackViewsToSuperview() {
        addSubview(stackViewForDay)
        stackViews.forEach {
            stackViewForDay.addArrangedSubview($0)
        }
        addSubview(stackViewLabelHour)
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
            stackViewForDay.heightAnchor.constraint(greaterThanOrEqualToConstant: 10)
        ])
    }

    private func setupHourlyViewInStackView () {
        stackViews.forEach {
            for _ in 1...48 {
                let view = UIView()
                view.backgroundColor = .systemGray6
                view.layer.cornerRadius = 1
                view.layer.borderWidth = 1
                view.layer.borderColor = UIColor.systemGray3.cgColor
                view.clipsToBounds = true
                $0.addArrangedSubview(view)
                view.translatesAutoresizingMaskIntoConstraints = false
                if styleOfGraph == .round || styleOfGraph == .ligne {
                    view.heightAnchor.constraint(equalTo: view.widthAnchor).isActive = true
                }
            }
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
        guard startedIndex < 48, endIndex <= 48 else {return}
        stackViews.forEach {
            if $0.arrangedSubviews.count > endIndex {
                for index in startedIndex...endIndex {
                    let view = $0.arrangedSubviews[index]
                    view.backgroundColor = color
                    view.layer.borderColor = color.cgColor
                }
            }
        }
    }

    private func colorGraphNumber(_ number: Int, with color: UIColor, startedIndex: Int, endIndex: Int) {
        guard startedIndex < 48, endIndex <= 48, number < stackViews.count else {return}
        let currentStackView = stackViews[number]
        for index in startedIndex...endIndex {
            let view = currentStackView.arrangedSubviews[index]
            view.backgroundColor = color
            view.layer.borderColor = color.cgColor
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
}
