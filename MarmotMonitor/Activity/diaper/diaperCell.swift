//
//  diaperCell.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 25/12/2023.
//

import UIKit

class DiaperCell: UITableViewCell {

    // MARK: - liste of UI elements
    let title: UILabel = {
        let label = UILabel()
        label.setupDynamicTextWith(policeName: "Symbol", size: 15, style: .body)
        label.textColor = .label
        label.textAlignment = .left
        label.numberOfLines = 0
        label.backgroundColor = .clear
        label.setAccessibility(with: .header, label: "Etat de la couche", hint: "")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var statusImage: UIImageView =  {
        let image = UIImageView()
        image.image = UIImage(systemName: "square")!
            .applyingSymbolConfiguration(.init(pointSize: 15))
        image.setAccessibility(with: .button, label: "", hint: "selection de l'etat de la couche")
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
    // MARK: - UI
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
            statusImage.heightAnchor.constraint(equalTo: title.heightAnchor),
            statusImage.heightAnchor.constraint(greaterThanOrEqualToConstant: 25)
        ])

        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            title.rightAnchor.constraint(equalTo: statusImage.leftAnchor, constant: -10),
            title.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            title.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }

    // MARK: - Setup cell
    func setupCell(with title: String, selected: Bool) {
        self.title.text = title
        setupImage(selected)
    }

    private func setupImage(_ selected: Bool) {
        let imageNotSelected = UIImage(systemName: "circle")!
            .applyingSymbolConfiguration(.init(pointSize: 15))
        let imageSelected = UIImage(systemName: "checkmark.circle")!
            .applyingSymbolConfiguration(.init(pointSize: 15))
        statusImage.image = selected ? imageSelected : imageNotSelected
    }

}
