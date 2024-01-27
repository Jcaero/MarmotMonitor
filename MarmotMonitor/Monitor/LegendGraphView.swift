//
//  LegendGraph.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 24/01/2024.
//

import UIKit

class LegendGraphView: UIView {
    let information: UILabel = {
        let label = UILabel()
        label.setupDynamicTextWith(policeName: "Symbol", size: 15, style: .body)
        label.textColor = .label
        label.textAlignment = .left
        label.numberOfLines = 1
        label.backgroundColor = .clear
        label.setAccessibility(with: .header, label: "resumé", hint: "")
        return label
    }()

    let imageActivity = UIImageView()

    // MARK: - INIT
    init(information: String, imageName: String) {
        super.init(frame: .zero)
        self.backgroundColor = .clear
        self.information.text = information
        if let image = UIImage(named: imageName) {
            imageActivity.image = image
        }

        setupContrainte()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupContrainte() {
        information.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            information.topAnchor.constraint(equalTo: topAnchor, constant: 2),
            information.rightAnchor.constraint(equalTo: rightAnchor, constant: -2),
            information.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2)
        ])

        imageActivity.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageActivity.topAnchor.constraint(equalTo: information.topAnchor),
            imageActivity.bottomAnchor.constraint(equalTo: information.bottomAnchor),
            imageActivity.widthAnchor.constraint(equalTo: imageActivity.heightAnchor),
            imageActivity.leftAnchor.constraint(equalTo: leftAnchor, constant: 2),
            information.leftAnchor.constraint(equalTo: imageActivity.rightAnchor, constant: 5)
        ])
    }
}
