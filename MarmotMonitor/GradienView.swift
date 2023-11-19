//
//  GradienView.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 19/11/2023.
//

import Foundation
import UIKit

class GradientView: UIView {
    let gradientLayer = CAGradientLayer()

    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: self.layer)
        gradientLayer.frame = self.bounds
    }

    init(with color: UIColor, color2: UIColor) {
        super.init(frame: .zero)
        gradientLayer.colors = [color.cgColor, color2.cgColor, color.cgColor]
        gradientLayer.locations = [0.0, 0.5, 1.0]
        self.layer.insertSublayer(gradientLayer, at: 0)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
