//
//  InformationUserSetting.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 04/02/2024.
//

import UIKit

class InformationUserSetting: UITableViewCell {
    private let area: UIView = {
        let view = UIView()
        view.backgroundColor = .colorForGraphBackground
        view.layer.cornerRadius = 20
        view.setupShadow(radius: 1, opacity: 0.5)
        return view
    }()

    private let emptyView: UIView = {
        let view = UIView()
        return view
    }()

    private let emptyView2: UIView = {
        let view = UIView()
        return view
    }()

    private let areaStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .equalSpacing
        return view
    }()

    private let buttonStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
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

    private let name: UILabel = {
        let label = UILabel()
        label.setupDynamicBoldTextWith(policeName: "Symbol", size: 20, style: .body)
        label.textColor = .colorForLabelBlackToBlue
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()

    private let birthDay: UILabel = {
        let label = UILabel()
        label.setupDynamicTextWith(policeName: "Symbol", size: 20, style: .body)
        label.textColor = .colorForLabelBlackToBlue
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()

    private let parentName: UILabel = {
        let label = UILabel()
        label.setupDynamicTextWith(policeName: "Symbol", size: 17, style: .body)
        label.textColor = .systemGray
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()

    private let babyImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "nameMarmotte")
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        return imageView
    }()

    private let modifierButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.plain()
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 5, bottom: 2, trailing: 5)
        configuration.baseBackgroundColor = UIColor.duckBlue
        configuration.background.cornerRadius = 10
        configuration.cornerStyle = .large
        configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { titleAttributes in
            var titleAttributes = titleAttributes
            titleAttributes.font = UIFont.preferredFont(forTextStyle: .footnote)
            return titleAttributes
        }
        button.configuration = configuration
        button.setTitle("Modifier", for: .normal)
        button.setTitleColor(UIColor.buttonCancel, for: .normal)
        button.setupShadow(radius: 1, opacity: 0.5)
        return button
    }()

    // MARK: - Properties
    static let reuseIdentifier = "InformationUserSettingCell"

    // MARK: - INIT
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear

        setupViews()
        setupContraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        addSubview(area)
        area.translatesAutoresizingMaskIntoConstraints = false

        [babyImage, areaStackView ].forEach {
            area.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        [informationStackView, buttonStackView].forEach {
            areaStackView.addArrangedSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        [emptyView, modifierButton, emptyView2].forEach {
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
            area.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            area.leftAnchor.constraint(equalTo: leftAnchor, constant: 5),
            area.rightAnchor.constraint(equalTo: rightAnchor, constant: -5),
            area.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),

            babyImage.centerYAnchor.constraint(equalTo: area.centerYAnchor),
            babyImage.leftAnchor.constraint(equalTo: area.leftAnchor, constant: 10),
            babyImage.heightAnchor.constraint(equalTo: babyImage.widthAnchor),
            babyImage.widthAnchor.constraint(equalTo: area.widthAnchor, multiplier: 0.2),

            areaStackView.topAnchor.constraint(equalTo: area.topAnchor, constant: 10),
            areaStackView.leftAnchor.constraint(equalTo: babyImage.rightAnchor, constant: 10),
            areaStackView.bottomAnchor.constraint(equalTo: area.bottomAnchor, constant: -10),
            areaStackView.rightAnchor.constraint(equalTo: area.rightAnchor, constant: -10)
        ])
    }

    func setupTitle(with name: String, birthDay: String, parent: String) {
        self.name.text = name
        self.birthDay.text = birthDay
        self.parentName.text = parent

    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let currentCategory = traitCollection.preferredContentSizeCategory
        areaStackView.axis = currentCategory.isAccessibilityCategory ? .vertical : .horizontal
        layoutIfNeeded()
    }
}
