//
//  DiaperCell.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 25/12/2023.
//

import UIKit
/// DiaperCell
/// This class is used to create diaper Cell
/// The user can select status
/// cell have 2 elements:
/// - title:  diaper status
/// - statusImage: fill with a square when selected
/// init with func setupCell(with title: String, selected: Bool)
class DiaperCell: UITableViewCell {

    // MARK: - liste of UI elements
    let title: UILabel = {
        let label = UILabel()
        label.setupDynamicTextWith(policeName: "Symbol", size: 15, style: .body)
        label.textColor = .label
        label.textAlignment = .left
        label.numberOfLines = 0
        label.backgroundColor = .clear
        label.isAccessibilityElement = false
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var statusImage: UIImageView =  {
        let image = UIImageView()
        image.image = UIImage(systemName: "square")!
            .applyingSymbolConfiguration(.init(pointSize: 15))
        image.tintColor = .duckBlue
        return image
    }()

    // MARK: - Properties
    static let reuseIdentifier = "DiaperCell"

    // MARK: - cycle life
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupContraint()
        self.backgroundColor = .clear
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - setup
    private func setupUI() {
        [title, statusImage].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    private func setupContraint() {
        NSLayoutConstraint.activate([
            statusImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            statusImage.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
            statusImage.heightAnchor.constraint(equalTo: statusImage.widthAnchor),
            statusImage.heightAnchor.constraint(greaterThanOrEqualToConstant: 25),

            title.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            title.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            title.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            title.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.7)
        ])
    }

    // MARK: - Setup cell
    func setupCell(with title: String, selected: Bool) {
        self.title.text = title
        setupImage(selected)
        let value = selected ? "selectionné" : "non selectionné"
        statusImage.setAccessibility(with: .button, label: title + " " + value, hint: "")
    }

    private func setupImage(_ selected: Bool) {
        let imageNotSelected = UIImage(systemName: "circle")!
            .applyingSymbolConfiguration(.init(pointSize: 15))
        let imageSelected = UIImage(systemName: "checkmark.circle")!
            .applyingSymbolConfiguration(.init(pointSize: 15))
        statusImage.image = selected ? imageSelected : imageNotSelected
    }

}
