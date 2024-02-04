//
//  HeaderSettingView.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 04/02/2024.
//

import UIKit

class HeaderSettingView: UIView {
    let title: UILabel = {
        let label = UILabel()
        label.setupDynamicBoldTextWith(policeName: "Symbol", size: 25, style: .title3)
        label.textColor = .colorForLabelBlackToBlue
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        setupViews()
        setupContraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        addSubview(title)
    }

    private func setupContraints() {
        title.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: topAnchor, constant: 2),
            title.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            title.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            title.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2)
        ])
    }

    func setupTitle(with title: String) {
        self.title.text = title
    }
}
