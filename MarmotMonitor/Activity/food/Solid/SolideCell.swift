//
//  SolideCell.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 18/12/2023.
//

import UIKit

class SolideCell: UITableViewCell {

    // MARK: - liste of UI elements
    let poids: UILabel = {
        let label = UILabel()
        label.setupDynamicTextWith(policeName: "Symbol", size: 20, style: .body)
        label.text = "0"
        label.textColor = .white
        label.textAlignment = .left
        label.numberOfLines = 1
        label.setAccessibility(with: .header, label: "poids de l'ingredient", hint: "")
        return label
    }()

    let type: UILabel = {
        let label = UILabel()
        label.setupDynamicTextWith(policeName: "Symbol", size: 20, style: .body)
        label.text = "g"
        label.textColor = .white
        label.textAlignment = .left
        label.numberOfLines = 1
        label.setAccessibility(with: .header, label: "", hint: "")
        return label
    }()

    // MARK: - Properties
    static let reuseIdentifier = "SolideCell"

    // MARK: - cycle life
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        self.backgroundColor = .red
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI
    private func setupUI() {
        [poids, type].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        addSubview(type)
        NSLayoutConstraint.activate([
            type.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            type.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
            type.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
        ])

        addSubview(poids)
        NSLayoutConstraint.activate([
            poids.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            poids.rightAnchor.constraint(equalTo: type.leftAnchor, constant: -10),
            poids.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
        ])
    }

    // MARK: - Setup cell
    func setupCell(with ingredient: String) {
    }
}
