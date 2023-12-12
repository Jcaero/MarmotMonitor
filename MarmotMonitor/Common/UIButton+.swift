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
}
