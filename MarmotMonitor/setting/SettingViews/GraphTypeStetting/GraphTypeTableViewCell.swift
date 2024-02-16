//
//  GraphTypeTableViewCell.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 15/02/2024.
//

import UIKit

final class GraphTypeTableViewCell: UITableViewCell {
    private let subtitleView: UILabel = {
        let label = UILabel()
        label.setupDynamicTextWith(policeName: "Symbol", size: 20, style: .title3)
        label.textColor = .colorForLabelBlackToBlue
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()

    private let graph: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        return imageView
    }()

    private let radioButton: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    // MARK: - Properties
    static let reuseIdentifier = "GraphTypeCell"

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
        [subtitleView, radioButton, graph].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    private func setupContraints() {
        NSLayoutConstraint.activate([
            subtitleView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            subtitleView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            subtitleView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),

            graph.topAnchor.constraint(equalTo: subtitleView.bottomAnchor),
            graph.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            graph.heightAnchor.constraint(equalTo: graph.widthAnchor, multiplier: 0.3),

            radioButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            radioButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            radioButton.heightAnchor.constraint(equalTo: radioButton.widthAnchor),

            graph.trailingAnchor.constraint(equalTo: radioButton.leadingAnchor, constant: -10),
            graph.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    func configure(with graphType: String, isSelected: Bool) {

        subtitleView.text = graphType

        switch graphType {
        case "pixel":
            graph.image = UIImage(named: "pixelGraph")
        case "Barre":
            graph.image = UIImage(named: "rodGraph")
        default:
            graph.image = UIImage(named: "ligneGraph")
        }

        radioButton.image = isSelected ? UIImage(systemName: "record.circle") : UIImage(systemName: "circle.circle")
        if traitCollection.preferredContentSizeCategory.isAccessibilityCategory {
            backgroundColor = isSelected ? .systemGreen.withAlphaComponent(0.3) : .clear
        }
    }

}
