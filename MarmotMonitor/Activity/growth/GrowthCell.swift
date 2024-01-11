//
//  GrowthCell.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 26/12/2023.
//

import UIKit

class GrowthCell: UITableViewCell {

    // MARK: - liste of UI elements
    let category: UILabel = {
        let label = UILabel()
        label.setupDynamicTextWith(policeName: "Symbol", size: 20, style: .body)
        label.text = "0"
        label.textColor = .label
        label.textAlignment = .left
        label.numberOfLines = 0
        label.backgroundColor = .clear
        label.setAccessibility(with: .header, label: "categorie", hint: "")
        return label
    }()

    let valueTF: UITextField = {
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
        textField.keyboardType = .decimalPad
        textField.backgroundColor = .clear
        textField.tintColor = .label
        textField.adjustsFontSizeToFitWidth = true
        textField.setAccessibility(with: .keyboardKey, label: "", hint: "inserer la valeur")
        return textField
    }()

    let unitOfMesure: UILabel = {
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
    static let reuseIdentifier = "GrowthCell"

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
    // MARK: - UI
    private func setupUI() {
        [category, valueTF, unitOfMesure].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        contentView.addSubview(category)
        contentView.addSubview(unitOfMesure)
        contentView.addSubview(valueTF)

        prepareContraint()
        addDoneButtonToDecimalPad()
    }

    private func prepareContraint() {
        bigSizeContrainte = [
            category.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            category.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            category.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.9),
            valueTF.topAnchor.constraint(equalTo: category.bottomAnchor, constant: 10),
            valueTF.rightAnchor.constraint(equalTo: unitOfMesure.leftAnchor, constant: -10),
            valueTF.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            valueTF.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.9),
            unitOfMesure.topAnchor.constraint(equalTo: category.bottomAnchor, constant: 5),
            unitOfMesure.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
            unitOfMesure.bottomAnchor.constraint(equalTo: valueTF.bottomAnchor)
        ]

        normalSizeContrainte = [
            category.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            category.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.40),
            category.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            valueTF.topAnchor.constraint(equalTo: category.topAnchor),
            valueTF.rightAnchor.constraint(equalTo: unitOfMesure.leftAnchor, constant: -10),
            valueTF.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.40),
            category.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            valueTF.bottomAnchor.constraint(equalTo: category.bottomAnchor, constant: -5),
            unitOfMesure.topAnchor.constraint(equalTo: valueTF.topAnchor),
            unitOfMesure.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
            unitOfMesure.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.1),
            unitOfMesure.bottomAnchor.constraint(equalTo: valueTF.bottomAnchor)
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
    func setupCell(with category: GrowthField, value: Double) {
        self.category.text = category.title
        self.unitOfMesure.text = category.unit
        setupTF(with: value)
    }

    private func setupTF(with value: Double) {
        if value == 0 {
            self.valueTF.placeholder = "0"
        } else {
            self.valueTF.text = String(value)
        }
        self.valueTF.accessibilityLabel = value == 0 ? "0" : String(value)
    }

    // MARK: - Setup keyboard
    func addDoneButtonToDecimalPad() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))

        toolbar.setItems([flexSpace, doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true

        valueTF.inputAccessoryView = toolbar
    }

    @objc func doneButtonAction() {
        // Dismiss the keyboard
        valueTF.resignFirstResponder()
    }
}

extension GrowthCell: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        valueTF.placeholder = ""
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
