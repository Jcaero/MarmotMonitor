//
//  SolideCell.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 18/12/2023.
//

import UIKit
/// SolideCell
/// This class is used to create food cell
/// The user can put the weight of the food
/// cell have 3 elements:
/// - ingredient: name of ingredient
/// - poidsTF: UITextField to put the weight of the food
/// - type:  unit f mesure
/// init with setupCell(with ingredient: Ingredient, value: Int)
class SolideCell: UITableViewCell {

    // MARK: - liste of UI elements
    let ingredient: UILabel = {
        let label = UILabel()
        label.setupDynamicTextWith(policeName: "Symbol", size: 20, style: .body)
        label.text = "0"
        label.textColor = .label
        label.textAlignment = .left
        label.numberOfLines = 0
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isAccessibilityElement = false
        return label
    }()

    let poidsTF: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(
            string: "0",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.label]
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
        return textField
    }()

    let type: UILabel = {
        let label = UILabel()
        label.setupDynamicTextWith(policeName: "Symbol", size: 20, style: .body)
        label.text = "g"
        label.textColor = .label
        label.textAlignment = .left
        label.numberOfLines = 1
        label.isAccessibilityElement = false
        return label
    }()

    // MARK: - Properties
    static let reuseIdentifier = "SolideCell"

    var normalSizeContrainte: [NSLayoutConstraint] = []
    var bigSizeContrainte: [NSLayoutConstraint] = []

    // MARK: - cycle life
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        self.backgroundColor = .clear
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - setup
    private func setupUI() {
        [poidsTF, type].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        contentView.addSubview(ingredient)
        contentView.addSubview(type)
        contentView.addSubview(poidsTF)

        prepareContraint()
    }

    private func prepareContraint() {
        bigSizeContrainte = [
            ingredient.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            ingredient.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            ingredient.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.9),
            poidsTF.topAnchor.constraint(equalTo: ingredient.bottomAnchor, constant: 10),
            poidsTF.rightAnchor.constraint(equalTo: type.leftAnchor, constant: -10),
            poidsTF.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            poidsTF.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.9),
            type.topAnchor.constraint(equalTo: ingredient.bottomAnchor, constant: 5),
            type.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
            type.bottomAnchor.constraint(equalTo: poidsTF.bottomAnchor)
        ]

        normalSizeContrainte = [
            ingredient.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            ingredient.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.40),
            ingredient.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            poidsTF.topAnchor.constraint(equalTo: ingredient.topAnchor),
            poidsTF.rightAnchor.constraint(equalTo: type.leftAnchor, constant: -10),
            poidsTF.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.40),
            ingredient.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            poidsTF.bottomAnchor.constraint(equalTo: ingredient.bottomAnchor, constant: -5),
            type.topAnchor.constraint(equalTo: poidsTF.topAnchor),
            type.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
            type.bottomAnchor.constraint(equalTo: poidsTF.bottomAnchor)
        ]

        let currentCategory = traitCollection.preferredContentSizeCategory
        let isAccessibilityCategory = currentCategory.isAccessibilityCategory

        if isAccessibilityCategory {
            NSLayoutConstraint.activate(bigSizeContrainte)
        } else {
            NSLayoutConstraint.activate(normalSizeContrainte)
        }
    }

    // MARK: - Setup cell
    func setupCell(with ingredient: Ingredient, value: Int) {
        self.ingredient.text = ingredient.rawValue
        if value == 0 {
            self.poidsTF.placeholder = "0"
        } else {
            self.poidsTF.text = String(value)
        }
        poidsTF.setAccessibility(with: .keyboardKey, label: "", hint: "inserer le poids de l'ingredient " + ingredient.rawValue)
        self.poidsTF.accessibilityLabel = value == 0 ? "0" : String(value)
    }
}

extension SolideCell: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        poidsTF.placeholder = ""
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if ((textField.text?.isEmpty) == true) {
            textField.attributedPlaceholder = NSAttributedString(
                string: "0",
                attributes: [NSAttributedString.Key.foregroundColor: UIColor.label]
            )
        }
    }
}
