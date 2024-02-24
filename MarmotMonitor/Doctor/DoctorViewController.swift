//
//  DoctorViewController.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 01/02/2024.
//

import UIKit
import DGCharts

class DoctorViewController: BackgroundViewController, ChartViewDelegate {

    lazy var lineChartView: LineChartView = {
        let chartView = LineChartView()
        chartView.backgroundColor = .clear
        chartView.rightAxis.enabled = false
        chartView.legend.enabled = false

        let yAxis = chartView.leftAxis
        yAxis.labelFont = .boldSystemFont(ofSize: 12)
        yAxis.setLabelCount(10, force: false)
        yAxis.labelTextColor = .label
        yAxis.axisLineColor = .label
        yAxis.labelPosition = .outsideChart
        yAxis.axisMinimum = 0

        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .boldSystemFont(ofSize: 12)
        xAxis.setLabelCount(6, force: false)
        xAxis.labelTextColor = .label
        xAxis.axisLineColor = .label
        xAxis.granularity = 1
        xAxis.valueFormatter = CustomAxisValueFormatter()
        xAxis.labelRotationAngle = -45
        xAxis.centerAxisLabelsEnabled = true
        chartView.setAccessibility(with: .image, label: "graphique de l'evolution", hint: "")
        return chartView
    }()

    let selectedGraph: UISegmentedControl = {
        let control = UISegmentedControl(items: ["Taille", "Poids"])
        let font = UIFont.preferredFont(forTextStyle: .caption1)
        control.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
        control.selectedSegmentTintColor = .colorForGraphBackground
        control.selectedSegmentIndex = 0
        control.setupShadow(radius: 2, opacity: 0.5)
        return control
    }()

    lazy var area: UIView = {
        let view = UIView()
        view.backgroundColor = .colorForGraphBackground
        view.layer.cornerRadius = 10
        view.layer.shadowColor = UIColor.black.cgColor
        view.setupShadow(radius: 2, opacity: 0.5)
        return view
    }()

    // MARK: - Properties
    let viewModel = DoctorViewModel()
    var segmentedControlHeightConstraint: NSLayoutConstraint!

    // MARK: - Cycle Life
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        viewModel.updateData()
        setupViews()
        setupContraint()

        setDataHeight()
        selectedGraph.addTarget(self, action: #selector(changeGraph), for: .valueChanged)
        adjustSegmentedControlHeightWithAutoLayout()
    }

    override func viewWillAppear(_ animated: Bool) {
        adjustSegmentedControlHeightWithAutoLayout()
        updateView()
    }

    override func viewIsAppearing(_ animated: Bool) {
        adjustSegmentedControlHeightWithAutoLayout()
        updateView()
    }

    // MARK: - setup
    private func setupViews() {
        view.addSubview(selectedGraph)
        view.addSubview(area)
        area.addSubview(lineChartView)
    }

    private func setupContraint() {
        area.translatesAutoresizingMaskIntoConstraints = false
        lineChartView.translatesAutoresizingMaskIntoConstraints = false
        selectedGraph.translatesAutoresizingMaskIntoConstraints = false

        segmentedControlHeightConstraint = selectedGraph.heightAnchor.constraint(equalToConstant: 40)
        adjustSegmentedControlHeightWithAutoLayout()

        NSLayoutConstraint.activate([
            selectedGraph.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            selectedGraph.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            selectedGraph.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            segmentedControlHeightConstraint,

            area.topAnchor.constraint(equalTo: selectedGraph.bottomAnchor, constant: 20),
            area.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            area.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            area.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),

            lineChartView.topAnchor.constraint(equalTo: area.topAnchor, constant: 5),
            lineChartView.leadingAnchor.constraint(equalTo: area.leadingAnchor, constant: 5),
            lineChartView.trailingAnchor.constraint(equalTo: area.trailingAnchor, constant: -5),
            lineChartView.bottomAnchor.constraint(equalTo: area.bottomAnchor, constant: -5)
        ])
    }

    private func setDataHeight() {
        var dataSetHeight = LineChartDataSet(entries: viewModel.weightValues, label: "")
        dataSetHeight = setupGraphData(of: dataSetHeight)

        let data = LineChartData(dataSet: dataSetHeight )
        data.setValueTextColor(.clear)
        lineChartView.data = data
    }

    private func setDataWeight() {
        var dataSetWeight = LineChartDataSet(entries: viewModel.weightValues, label: "")
        dataSetWeight = setupGraphData(of: dataSetWeight)

        let data = LineChartData(dataSet: dataSetWeight)
        data.setValueTextColor(.clear)
        lineChartView.data = data
    }

    private func setupGraphData(of set: LineChartDataSet) -> LineChartDataSet {
        let set = set
        set.drawCirclesEnabled = false
        set.colors = [UIColor.colorForGraphLigne]
        set.mode = .cubicBezier
        set.lineWidth = 3

        set.highlightEnabled = true

        let gradientColors = [UIColor.darkBlue.cgColor, UIColor.lightBlue.cgColor] as CFArray // Colors of the gradient
        let colorLocations:[CGFloat] = [1.0, 0.0] // Positioning of the gradient
        let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations) // Gradient Object
        set.fill = LinearGradientFill(gradient: gradient!, angle: 90.0)
        set.drawFilledEnabled = true // Draw the Gradient
        return set
    }

    // MARK: - SagmentedControl
    @objc private func changeGraph() {
        updateView()
    }

    private func updateView() {
        viewModel.updateData()
        if selectedGraph.selectedSegmentIndex == 0 {
            setDataHeight()
        } else {
            setDataWeight()
        }
    }

    /// Adjust the segmented control height with auto layout
    /// - Parameter control: the segmented control to adjust
    /// - Note: The segmented control height is adjusted with the font size
    func adjustSegmentedControlHeightWithAutoLayout() {
        let font = UIFont.preferredFont(forTextStyle: .body)
        selectedGraph.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
        selectedGraph.apportionsSegmentWidthsByContent = true

        let testLabel = UILabel()
        testLabel.font = font
        testLabel.text = "Test"
        testLabel.sizeToFit()
        let newHeight = testLabel.frame.size.height + 16

        segmentedControlHeightConstraint.constant = newHeight
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        adjustSegmentedControlHeightWithAutoLayout()
    }
}
