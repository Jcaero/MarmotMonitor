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
        label.numberOfLines = 0
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
}
