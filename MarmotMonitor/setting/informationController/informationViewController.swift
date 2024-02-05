//
//  informationViewController.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 05/02/2024.
//

import UIKit

class InformationViewController: BackgroundViewController {
    private let area: UIView = {
        let view = UIView()
        view.backgroundColor = .colorForGraphBackground
        view.layer.cornerRadius = 20
        view.setupShadow(radius: 1, opacity: 0.5)
        return view
    }()

    private let buttonStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .equalSpacing
        return view
    }()

    private let informationStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .equalSpacing
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private var name: UITextField!
    private var birthDay: UITextField!
    private var parentName: UITextField!

    private let babyImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "nameMarmotte")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let saveButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.filled()
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 5, bottom: 2, trailing: 5)
        configuration.baseBackgroundColor = UIColor.colorForDuckBlueToWhite
        configuration.background.cornerRadius = 10
        configuration.cornerStyle = .large
        configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { titleAttributes in
            var titleAttributes = titleAttributes
            titleAttributes.font = UIFont.preferredFont(forTextStyle: .footnote)
            return titleAttributes
        }
        button.configuration = configuration
        button.setTitle("Enegistrer", for: .normal)
        button.setupShadow(radius: 1, opacity: 0.5)
        return button
    }()

    private let cancelButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.filled()
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 5, bottom: 2, trailing: 5)
        configuration.baseBackgroundColor = UIColor.colorForDuckBlueToWhite
        configuration.background.cornerRadius = 10
        configuration.cornerStyle = .large
        configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { titleAttributes in
            var titleAttributes = titleAttributes
            titleAttributes.font = UIFont.preferredFont(forTextStyle: .footnote)
            return titleAttributes
        }
        button.configuration = configuration
        button.setTitle("annuler", for: .normal)
        button.setupShadow(radius: 1, opacity: 0.5)
        return button
    }()

    // MARK: - Properties
    private let viewModel = InformationViewModel()

    // MARK: - INIT
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTextField()

        setupViews()
        setupContraints()
    }

    private func setupTextField() {
        viewModel.getUserInformation()
        name = createTextField()
        name.placeholder = viewModel.babyName
        birthDay = createTextField()
        birthDay.placeholder = viewModel.birthDay
        parentName = createTextField()
        parentName.placeholder = viewModel.parentName
    }
    private func setupViews() {
        view.addSubview(area)
        area.translatesAutoresizingMaskIntoConstraints = false

        [babyImage, informationStackView, buttonStackView ].forEach {
            area.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        let empty = UIView()
        let empty2 = UIView()
        let empty3 = UIView()
        [empty, cancelButton, empty3, saveButton, empty2].forEach {
            buttonStackView.addArrangedSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        [name, birthDay, parentName].forEach {
            informationStackView.addArrangedSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    private func setupContraints() {
        NSLayoutConstraint.activate([
            area.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            area.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -30),
            area.widthAnchor.constraint(equalToConstant: view.frame.width * 0.85),
            area.heightAnchor.constraint(equalTo: area.widthAnchor, multiplier: 0.5),

            babyImage.centerYAnchor.constraint(equalTo: area.centerYAnchor),
            babyImage.leftAnchor.constraint(equalTo: area.leftAnchor, constant: 10),
            babyImage.heightAnchor.constraint(equalTo: babyImage.widthAnchor),
            babyImage.widthAnchor.constraint(equalTo: area.widthAnchor, multiplier: 0.2),

            informationStackView.topAnchor.constraint(equalTo: area.topAnchor, constant: 10),
            informationStackView.leftAnchor.constraint(equalTo: babyImage.rightAnchor, constant: 10),
            informationStackView.rightAnchor.constraint(equalTo: area.rightAnchor, constant: -10),
            informationStackView.bottomAnchor.constraint(equalTo: area.bottomAnchor, constant: -10),

            buttonStackView.topAnchor.constraint(equalTo: area.bottomAnchor, constant: 10),
            buttonStackView.leftAnchor.constraint(equalTo: area.leftAnchor, constant: 10),
            buttonStackView.rightAnchor.constraint(equalTo: area.rightAnchor, constant: -10)
        ])
    }

    func setupTitle(with name: String, birthDay: String, parent: String) {
        self.name.text = name
        self.birthDay.text = birthDay
        self.parentName.text = parent

    }

}

extension InformationViewController {
    private func createTextField() -> UITextField {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(
            string: "0",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.label]
        )
        let font = UIFont(name: "Symbol", size: 20)
        let fontMetrics = UIFontMetrics(forTextStyle: .body)
        textField.font = fontMetrics.scaledFont(for: font!)
        textField.textColor = .label
        textField.textAlignment = .left
        textField.borderStyle = .roundedRect
        textField.layer.borderColor = UIColor.duckBlue.cgColor
        textField.layer.borderWidth = 2
        textField.layer.cornerRadius = 10
        textField.keyboardType = .default
        textField.backgroundColor = .clear
        textField.tintColor = .label
        textField.adjustsFontSizeToFitWidth = true
        return textField
    }
}
