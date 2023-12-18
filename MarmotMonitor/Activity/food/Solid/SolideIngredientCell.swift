//
//  SolideIngredientCell.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 18/12/2023.
//

import UIKit

class SolideIngredientCell: UITableViewCell {

    // MARK: - liste of UI elements
    let ingredient: UILabel = {
        let label = UILabel()
        label.setupDynamicTextWith(policeName: "Symbol", size: 20, style: .body)
        label.text = "0"
        label.textColor = .white
        label.textAlignment = .left
        label.numberOfLines = 1
        label.setAccessibility(with: .header, label: "poids de l'ingredient", hint: "")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Properties
    static let reuseIdentifier = "SolideIngredientCell"

    // MARK: - cycle life
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        self.backgroundColor = .blue
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI
    private func setupUI() {
        addSubview(ingredient)
        NSLayoutConstraint.activate([
            ingredient.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            ingredient.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            ingredient.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            ingredient.heightAnchor.constraint(greaterThanOrEqualToConstant: 30)
        ])
    }

    // MARK: - Setup cell
    func setupCell(with ingredient: String) {
        self.ingredient.text = ingredient
    }
}
