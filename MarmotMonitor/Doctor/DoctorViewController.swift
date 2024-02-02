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

        chartView.animate(xAxisDuration: 1.5)

        return chartView
    }()

    lazy var area: UIView = {
        let view = UIView()
        view.backgroundColor = .colorForGraphBackground
        view.layer.cornerRadius = 10
        view.layer.shadowColor = UIColor.black.cgColor
        view.setupShadow(radius: 1, opacity: 0.5)
        return view
    }()

    let viewModel = DoctorViewModel()

    // MARK: - Cycle Life
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setupViews()
        setupContraint()

        setData()
    }

    // MARK: - setup
    private func setupViews() {
        view.addSubview(area)
        area.addSubview(lineChartView)
    }

    private func setupContraint() {
        area.translatesAutoresizingMaskIntoConstraints = false
        lineChartView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            area.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            area.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            area.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            area.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),

            lineChartView.topAnchor.constraint(equalTo: area.topAnchor, constant: 5),
            lineChartView.leadingAnchor.constraint(equalTo: area.leadingAnchor, constant: 5),
            lineChartView.trailingAnchor.constraint(equalTo: area.trailingAnchor, constant: -5),
            lineChartView.bottomAnchor.constraint(equalTo: area.bottomAnchor, constant: -5)
        ])
    }

    private func setData() {
        let set1 = LineChartDataSet(entries: viewModel.yValues, label: "")
        set1.drawCirclesEnabled = false
        set1.colors = [UIColor.colorForGraphLigne]
        set1.mode = .cubicBezier
        set1.lineWidth = 3

        set1.highlightEnabled = false

        let data = LineChartData(dataSet: set1)
        data.setValueTextColor(.clear)
        lineChartView.data = data
    }
}
