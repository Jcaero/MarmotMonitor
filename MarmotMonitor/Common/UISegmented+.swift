//
//  UISegmented+.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 16/12/2023.
//

import Foundation
import UIKit

extension UISegmentedControl {
    func setupSegmentedTitle(with title: [String]) {
        self.setTitle(title[0], forSegmentAt: 0)
        self.setTitle(title[1], forSegmentAt: 1)
    }
}
