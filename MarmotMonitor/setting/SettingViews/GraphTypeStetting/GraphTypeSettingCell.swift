//
//  GraphTypeSettingCell.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 07/02/2024.
//

import UIKit

class GraphTypeSettingCell: UITableViewCell {
    private let icone: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .duckBlue
        view.clipsToBounds = true
        return view
    }()

    private let name: UILabel = {
        let label = UILabel()
        label.setupDynamicBoldTextWith(policeName: "Symbol", size: 20, style: .body)
        label.textColor = .colorForDuckBlueToWhite
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()

    private let graph: UILabel = {
        let label = UILabel()
        label.setupDynamicBoldTextWith(policeName: "Symbol", size: 20, style: .body)
        label.textColor = .colorForDuckBlueToWhite
        label.textAlignment = .right
        label.numberOfLines = 0
        return label
    }()

    private let areaStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .equalSpacing
        return view
    }()

    // MARK: - Properties
    static let reuseIdentifier = "GraohTypeSettingCell"

    private var nameLeadingConstraint: NSLayoutConstraint?
    private var nameLeadingAccesibilityConstraint: NSLayoutConstraint?
    private var nameTrailingConstraint: NSLayoutConstraint?
    private var nameTrailingAccessibilityConstraint: NSLayoutConstraint?

    // MARK: - INIT
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear

        setupViews()
        setupContraints()

        icone.image = UIImage(named: "graphIcone")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        [name, icone, graph].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    private func setupContraints() {

//        nameTrailingConstraint =  name.trailingAnchor.constraint(equalTo: graph.leadingAnchor, constant: -15)
//        nameTrailingAccessibilityConstraint = name.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)

        NSLayoutConstraint.activate([
            icone.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            icone.heightAnchor.constraint(equalToConstant: frame.height * 0.65),
            icone.heightAnchor.constraint(equalTo: icone.widthAnchor),
            icone.centerYAnchor.constraint(equalTo: centerYAnchor),

            graph.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            graph.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            graph.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            graph.widthAnchor.constraint(equalToConstant: 100),

            name.leadingAnchor.constraint(equalTo: icone.trailingAnchor, constant: 10),
            name.trailingAnchor.constraint(equalTo: graph.leadingAnchor, constant: -15),
            name.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            name.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }

    func setupTitle(with name: String, type: GraphType) {
        self.name.text = name
        self.graph.text = type.description + " >"
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        icone.layer.cornerRadius = icone.frame.height / 8
        layoutIfNeeded()
    }
}
