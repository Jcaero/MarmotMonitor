//
//  Color+.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 21/11/2023.
//

import Foundation
import UIKit

extension UIColor {
    static let pastelBlue = UIColor(red: 0.52, green: 0.80, blue: 0.86, alpha: 1.00)
    static let darkBlue = UIColor(red: 0.16, green: 0.62, blue: 0.91, alpha: 1.00)

    // MARK: - Pink
    static let pastelPink = UIColor(red: 1.00, green: 0.66, blue: 0.78, alpha: 1.00)
    static let darkPink = UIColor(red: 0.93, green: 0.40, blue: 0.58, alpha: 1.00)
    static let heavyPink = UIColor(red: 0.91, green: 0.22, blue: 0.56, alpha: 1.00)

    // MARK: - Brown
    static let pastelBrown = UIColor(red: 0.75, green: 0.65, blue: 0.56, alpha: 1.00) // #c0a68f
    static let pastelHeavyBrown = UIColor(red: 0.39, green: 0.32, blue: 0.22, alpha: 1.00) // #645139
    static let mediumBrown = UIColor(red: 0.58, green: 0.42, blue: 0.27, alpha: 1.00) // #946b45
    static let darkBrown = UIColor(red: 0.64, green: 0.52, blue: 0.37, alpha: 1.00) // #a3855e

    // MARK: - Dark
    static let softBlack = UIColor(red: 0.07, green: 0.07, blue: 0.07, alpha: 1.00) // #121212
    static let softWhite = UIColor(red: 0.92, green: 0.92, blue: 0.92, alpha: 1.00) // #ebebeb

    // MARK: - Gradient
    static let colorForGradientStart = themed(light: .mediumBrown, dark: .softBlack)
    static let colorForGradientEnd = themed(light: .pastelBrown, dark: .darkGray)

    static let colorForPastelArea = themed(light: .pastelBrown, dark: .systemGray4)

    static let colorForLabelBlackToBrown = themed(light: .black, dark: .darkBrown)

    // MARK: - NextButton
    static let colorForNextButton = themed(light: .clear, dark: .clear)
    static let colorForLabelNextButtonDefault = themed(light: .softBlack, dark: .pastelBrown)
    static let colorForStokNextButton = themed(light: .white, dark: .darkGray)

    // MARK: - Today
    static let colorForDate = themed(light: .softWhite, dark: .lightGray)

}

private func themed(light: UIColor, dark: UIColor) -> UIColor {
    return UIColor(dynamicProvider: { trait -> UIColor in
        (trait.userInterfaceStyle == .dark) ? dark : light
    })
}
