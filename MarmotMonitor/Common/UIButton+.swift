//
//  UIButton+.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 11/12/2023.
//

import Foundation
import UIKit

extension UIButton {
    func setupDynamicTextWith( policeName: String, size: CGFloat, style: UIFont.TextStyle) {
        if let font = UIFont(name: policeName, size: size) {
            let fontMetrics = UIFontMetrics(forTextStyle: style)
            self.titleLabel?.font = fontMetrics.scaledFont(for: font)
        }
        self.titleLabel?.adjustsFontForContentSizeCategory = true
    }

    func createActionButton(color: UIColor) -> UIButton {
        let button = UIButton()
        var configuration = UIButton.Configuration.filled()
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 5, bottom: 10, trailing: 5)
        configuration.baseBackgroundColor = color.withAlphaComponent(0.95)
        configuration.baseForegroundColor = UIColor.white
        configuration.background.cornerRadius = 12
        configuration.cornerStyle = .large
        configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { titleAttributes in
            var titleAttributes = titleAttributes
            let descriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .footnote).withSymbolicTraits(.traitBold)
            titleAttributes.font = UIFont(descriptor: descriptor!, size: 0)
            return titleAttributes
        }
        button.configuration = configuration
        button.setupShadow(radius: 1, opacity: 0.5)
        button.layer.borderWidth = 4
        button.layer.borderColor = color.cgColor
        return button
    }
}
