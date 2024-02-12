//
//  UILabel+.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 19/11/2023.
//

import Foundation
import UIKit

extension UILabel {
    /// Setup your label with a dynamic font.
    /// - Parameters:
    ///   - policeName: Name of the font. see: https://developer.apple.com/fonts/
    ///   - size: size of the font.  see https://lickability.com/blog/dynamic-type-and-in-app-font-scaling/ for accessibility size
    ///   - style: style of the font: body, callout....
    func setupDynamicTextWith( policeName: String, size: CGFloat, style: UIFont.TextStyle) {
        if let font = UIFont(name: policeName, size: size) {
            let fontMetrics = UIFontMetrics(forTextStyle: style)
            self.font = fontMetrics.scaledFont(for: font)
        }
        self.adjustsFontForContentSizeCategory = true
        self.numberOfLines = 0
    }

    func setupDynamicBoldTextWith( policeName: String, size: CGFloat, style: UIFont.TextStyle) {
        let fontDescriptor = UIFont.systemFont(ofSize: size, weight: .bold).fontDescriptor.withDesign(.rounded)
        let fontMetrics = UIFontMetrics(forTextStyle: style)
        let font = UIFont(descriptor: fontDescriptor!, size: size)
        self.font = fontMetrics.scaledFont(for: font)
        self.adjustsFontForContentSizeCategory = true
        self.numberOfLines = 0
    }
}
