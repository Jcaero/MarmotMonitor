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

    func applyGradient(colors: [CGColor]) {
        let gradienName = "buttonGradient"

        if let layers = self.layer.sublayers {
            for layer in layers where layer.name == gradienName {
                layer.removeFromSuperlayer()
            }
        }

        self.backgroundColor = nil
        self.layoutIfNeeded()
        let gradientLayer = CAGradientLayer()
        gradientLayer.name = gradienName
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        gradientLayer.frame = self.bounds
        gradientLayer.cornerRadius = self.frame.height/2

        gradientLayer.shadowColor = UIColor.darkGray.cgColor
        gradientLayer.shadowOffset = CGSize(width: 2.5, height: 2.5)
        gradientLayer.shadowRadius = 5.0
        gradientLayer.shadowOpacity = 0.3
        gradientLayer.masksToBounds = false

        self.layer.insertSublayer(gradientLayer, at: 0)
        self.contentVerticalAlignment = .center
        self.setTitleColor(UIColor.buttonValidate, for: .normal)
        self.titleLabel?.textColor = UIColor.buttonValidate
    }
}
