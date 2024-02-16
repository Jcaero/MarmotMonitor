//
//  IconeSettingCell.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 10/02/2024.
//

import UIKit

final class IconeSettingCell: UICollectionViewCell {

    // MARK: - Properties
    static let reuseIdentifier = "IconeSettingCell"

    // MARK: - INIT
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.masksToBounds = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupColor(in color: UIColor) {
        backgroundColor = color
        layer.cornerRadius = frame.height / 2
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height / 2
        layoutIfNeeded()
    }
}
