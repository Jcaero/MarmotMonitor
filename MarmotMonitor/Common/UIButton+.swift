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

    func createActionButton(type: ButtonTypeAction) {
        let isValideButton = type == .valider
        var configuration = isValideButton ? UIButton.Configuration.plain() : UIButton.Configuration.tinted()
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        configuration.baseBackgroundColor = isValideButton ? UIColor.duckBlue : .clear
        configuration.background.cornerRadius = 10
        configuration.cornerStyle = .large
        configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { titleAttributes in
            var titleAttributes = titleAttributes
            titleAttributes.font = UIFont.preferredFont(forTextStyle: .body)
            return titleAttributes
        }
        self.configuration = configuration
        let title = isValideButton ? "Enregistrer" : "Retour"
        self.setTitle(title, for: .normal)
        self.setupShadow(radius: 1, opacity: 0.5)
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
        self.setTitleColor(.white, for: .normal)
        self.titleLabel?.textColor = UIColor.buttonValidate
    }

    func createBreastManuallyButton() {
        var configuration = UIButton.Configuration.bordered()
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        configuration.title = "Saisir Manuellement"
        configuration.titleAlignment = .center
        configuration.baseForegroundColor = .label
        configuration.baseBackgroundColor = .duckBlue.withAlphaComponent(0.6)
        //        configuration.background.strokeColor = .manualyBreastButton
        configuration.background.strokeWidth = 1
        configuration.background.cornerRadius = 10
        configuration.cornerStyle = .large
        configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { titleAttributes in
            var titleAttributes = titleAttributes
            let fontMetrics = UIFontMetrics(forTextStyle: .body)
            titleAttributes.font = fontMetrics.scaledFont(for: UIFont(name: "Symbol", size: 13)!)
            return titleAttributes
        }
        self.configuration = configuration
        self.titleLabel?.adjustsFontForContentSizeCategory = true
    }

    func createTimerPlayBreastButton() {
        var configuration = UIButton.Configuration.filled()
        configuration.image = UIImage(systemName: "play.fill")!
            .applyingSymbolConfiguration(.init(pointSize: 30))
        configuration.cornerStyle = .capsule
        configuration.baseBackgroundColor = .duckBlue.withAlphaComponent(0.6)
        configuration.baseForegroundColor = .label
        configuration.contentInsets = .zero
        self.configuration = configuration
    }
}

enum ButtonTypeAction {
    case valider
    case retour
}
