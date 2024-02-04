//
//  UIView+.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 19/11/2023.
//

import Foundation
import UIKit

extension UIView {
    /// define the accessibility of any view
    /// - Parameters:
    ///   - traits: describe how an accessibility element behaves exemple Button
    ///   - label: A succinct label in a localized string that identifies the accessibility element.
    ///   - hint: A localized string that contains a brief description of the result of performing an action on the accessibility element.
    func setAccessibility( with traits: UIAccessibilityTraits, label: String, hint: String) {
        self.isAccessibilityElement = true
        self.accessibilityTraits = traits
        self.accessibilityLabel = label
        self.accessibilityHint = hint
    }

    func setupShadow(radius: CGFloat, opacity: Float ) {
        self.layer.shadowOffset = CGSize(width: 3, height: 3)
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
    }

    /// Apply  No corner radius to the view
    func noCorners() {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: [.allCorners], cornerRadii: CGSize(width: 0, height: 0))
        let shape = CAShapeLayer()
        shape.path = path.cgPath
        layer.mask = shape
    }

    /// Apply corner radius to the view
    /// - Parameter corners: the corner to apply the radius
    /// - Parameter rect: the rect to apply the radius
    func applyCorners(position: UIRectCorner, with rect: CGRect) {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: position, cornerRadii: CGSize(width: 10, height: 10))
        let shape = CAShapeLayer()
        shape.path = path.cgPath
        layer.mask = shape
    }

}
