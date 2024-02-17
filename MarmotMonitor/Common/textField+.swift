//
//  textField+.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 16/02/2024.
//

import UIKit

extension UITextField {
    func underlined(color: UIColor) {
          let borderName = "bottomBorder"

          if let layers = self.layer.sublayers {
              for layer in layers where layer.name == borderName {
                      layer.removeFromSuperlayer()
              }
          }

          let border = CALayer()
          border.name = borderName
          let width = CGFloat(2.0)
          border.borderColor = color.cgColor
          border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: width)
          border.borderWidth = width
          self.layer.addSublayer(border)
          self.layer.masksToBounds = true
      }
  }
