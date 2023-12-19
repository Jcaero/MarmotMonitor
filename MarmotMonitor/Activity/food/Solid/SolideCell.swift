//
//  SolideCell.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 18/12/2023.
//

import UIKit

class SolideCell: UITableViewCell, UITextFieldDelegate {

    // MARK: - liste of UI elements
    let ingredient: UILabel = {
        let label = UILabel()
        label.setupDynamicTextWith(policeName: "Symbol", size: 20, style: .body)
        label.text = "0"
        label.textColor = .label
        label.textAlignment = .left
        label.numberOfLines = 0
        label.setAccessibility(with: .header, label: "poids de l'ingredient", hint: "")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let poids: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(
            string: "0",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.black]
        )
        let font = UIFont(name: "Symbol", size: 20)
        let fontMetrics = UIFontMetrics(forTextStyle: .body)
        textField.font = fontMetrics.scaledFont(for: font!)
        textField.adjustsFontForContentSizeCategory = true
        textField.textColor = .label
        textField.textAlignment = .right
        textField.borderStyle = .none
        textField.keyboardType = .numberPad
        textField.backgroundColor = .clear
        textField.tintColor = .label
        textField.adjustsFontSizeToFitWidth = true
        textField.setAccessibility(with: .keyboardKey, label: "", hint: "inserer le poids")
        return textField
    }()

    let type: UILabel = {
        let label = UILabel()
        label.setupDynamicTextWith(policeName: "Symbol", size: 20, style: .body)
        label.text = "g"
        label.textColor = .label
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
        self.backgroundColor = .clear
        poids.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI
    private func setupUI() {
        [poids, type].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        contentView.addSubview(ingredient)
        contentView.addSubview(type)
        contentView.addSubview(poids)

        NSLayoutConstraint.activate([
            ingredient.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            ingredient.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            ingredient.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.9)
        ])

        NSLayoutConstraint.activate([
            poids.topAnchor.constraint(equalTo: ingredient.bottomAnchor, constant: 10),
            poids.rightAnchor.constraint(equalTo: type.leftAnchor, constant: -10),
            poids.heightAnchor.constraint(greaterThanOrEqualToConstant: 40),
            poids.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            poids.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.9)
        ])

        NSLayoutConstraint.activate([
            type.topAnchor.constraint(equalTo: ingredient.bottomAnchor, constant: 5),
            type.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
            type.bottomAnchor.constraint(equalTo: poids.bottomAnchor)
        ])
    }

    // MARK: - Setup cell
    func setupCell(with ingredient: String) {
        self.ingredient.text = ingredient
    }
}
