//
//  LegendGraph.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 24/01/2024.
//

import UIKit
typealias LegendGraphData = (information: String, imageName: String, color: UIColor)

class LegendGraphView: UIView {
    let information: UILabel = {
        let label = UILabel()
        label.setupDynamicTextWith(policeName: "Symbol", size: 15, style: .body)
        label.textColor = .label
        label.textAlignment = .left
        label.numberOfLines = 0
        label.backgroundColor = .clear
        label.setAccessibility(with: .header, label: "resumé", hint: "")
        return label
    }()

    let imageActivity = UIImageView()

    var color: UIColor = .clear

    // MARK: - INIT
    init(data: LegendGraphData) {
        super.init(frame: .zero)
        self.backgroundColor = .clear
        self.information.text = data.information
        if let image = UIImage(named: data.imageName) {
            imageActivity.image = image
            color = getImageColor(imageName: data.imageName)
        }
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        [information, imageActivity].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }

        setupContrainte()
    }

    override func layoutSubviews() {
           super.layoutSubviews()
        imageActivity.layer.cornerRadius = self.frame.height / 2
        imageActivity.layer.backgroundColor = color.cgColor
       }

    private func setupContrainte() {

        NSLayoutConstraint.activate([
            imageActivity.topAnchor.constraint(equalTo: topAnchor, constant: 2),
            imageActivity.widthAnchor.constraint(equalTo: imageActivity.heightAnchor),
            imageActivity.leftAnchor.constraint(equalTo: leftAnchor, constant: 2),
            imageActivity.heightAnchor.constraint(equalToConstant: 30)
        ])

        NSLayoutConstraint.activate([
            information.topAnchor.constraint(equalTo: imageActivity.topAnchor),
            information.rightAnchor.constraint(equalTo: rightAnchor, constant: -2),
            information.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2),
            information.leftAnchor.constraint(equalTo: imageActivity.rightAnchor, constant: 5 )
        ])
    }

    private func getImageColor(imageName: String) -> UIColor {
        switch imageName {
        case ActivityIconName.meal.rawValue :
            return .colorForMeal
        case ActivityIconName.diaper.rawValue:
            return .colorForDiaper
        case ActivityIconName.sleep.rawValue:
            return .colorForSleep
        default:
            return .clear
        }
    }
}
