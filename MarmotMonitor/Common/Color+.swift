//
//  Color+.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 21/11/2023.
//

import Foundation
import UIKit

extension UIColor {
    // MARK: - New Colors
    static let pastelBlueNew = UIColor(red: 0.64, green: 0.82, blue: 1.00, alpha: 1.00) // #A2D2FF
    static let softGray = UIColor(red: 0.94, green: 0.97, blue: 1.00, alpha: 1.00) // #fafafa
    static let egyptienBlue = UIColor(red: 0.00, green: 0.20, blue: 0.40, alpha: 1.00) // #003366
    static let egyptienBlueSoft = UIColor(red: 0.20, green: 0.36, blue: 0.52, alpha: 1.00) // #335B84
    static let graySoft = UIColor(red: 0.91, green: 0.91, blue: 0.91, alpha: 1.00) // #E8E8E8
    static let pastelPinkNew = UIColor(red: 1.00, green: 0.78, blue: 0.87, alpha: 1.00) // #FFC8DD

    // MARK: - Pink
    static let pastelPink = UIColor(red: 1.00, green: 0.66, blue: 0.78, alpha: 1.00)
    static let darkPink = UIColor(red: 0.93, green: 0.40, blue: 0.58, alpha: 1.00)
    static let heavyPink = UIColor(red: 0.91, green: 0.22, blue: 0.56, alpha: 1.00)

    // MARK: - Brown
    static let pastelBrown = UIColor(red: 0.75, green: 0.65, blue: 0.56, alpha: 1.00) // #c0a68f
    static let pastelHeavyBrown = UIColor(red: 0.39, green: 0.32, blue: 0.22, alpha: 1.00) // #645139
    static let mediumBrown = UIColor(red: 0.58, green: 0.42, blue: 0.27, alpha: 1.00) // #946b45
    static let darkBrown = UIColor(red: 0.64, green: 0.52, blue: 0.37, alpha: 1.00) // #a3855e
    static let beige = UIColor(red: 0.73, green: 0.57, blue: 0.37, alpha: 1.00) // #b9925e

    // MARK: - Dark
    static let softBlack = UIColor(red: 0.07, green: 0.07, blue: 0.07, alpha: 1.00) // #121212
    static let softWhite = UIColor(red: 0.92, green: 0.92, blue: 0.92, alpha: 1.00) // #ebebeb

    // MARK: - Blue
    static let duckBlue = UIColor(red: 0.02, green: 0.55, blue: 0.60, alpha: 1.00) // #048B9A
    static let duckBlueAlpha = UIColor(red: 0.02, green: 0.55, blue: 0.60, alpha: 0.40) // #048B9A
    static let pastelBlue = UIColor(red: 0.52, green: 0.80, blue: 0.86, alpha: 1.00)
    static let darkBlue = UIColor(red: 0.16, green: 0.62, blue: 0.91, alpha: 1.00)
    static let lightBlue = UIColor(red: 0.68, green: 0.85, blue: 0.90, alpha: 1.00) // #ADD8E6
    static let dodgerBlue = UIColor(red: 0.12, green: 0.56, blue: 1.00, alpha: 1.00) // #1E90FF

    // MARK: - Red
    static let peach = UIColor(red: 1.00, green: 0.85, blue: 0.73, alpha: 1.00) // #FFDAB9
    static let OrangeDark = UIColor(red: 1.00, green: 0.55, blue: 0.00, alpha: 1.00) // #FF8C00

    // MARK: - Green
    static let pastelGreen = UIColor(red: 0.60, green: 0.98, blue: 0.60, alpha: 1.00) // #98FB98
    static let greenSea = UIColor(red: 0.18, green: 0.55, blue: 0.34, alpha: 1.00) // #2E8B57

    // MARK: - Gradient
    static let colorForGradientStart = themed(light: .pastelBlueNew, dark: .egyptienBlue)
    static let colorForGradientStartPink = themed(light: .pastelPinkNew, dark: .egyptienBlue)
    static let colorForGradientEnd = themed(light: .white, dark: .egyptienBlueSoft)

    static let colorForPastelArea = themed(light: .softGray, dark: .egyptienBlueSoft)

    static let colorForLabelBlackToBlue = themed(light: .black, dark: .graySoft)

    // MARK: - NextButton
    static let colorForNextButton = themed(light: .clear, dark: .clear)
    static let colorForLabelNextButtonDefault = themed(light: .softBlack, dark: .white)
    static let colorForStokNextButton = themed(light: .white, dark: .darkGray)

    // MARK: - Today
    static let colorForDate = themed(light: .softBlack, dark: .lightGray)

    // MARK: - BreastFeeding
    static let colorForBreastButton = themed(light: .duckBlueAlpha, dark: .softBlack)

    // MARK: - Common
    static let colorForDuckBlueToWhite = themed(light: .duckBlue, dark: .white)

    // MARK: - SolideIngredientCell
    static let colorForDuckBlueToClear = themed(light: .duckBlue, dark: .clear)

    // MARK: - GraphActivities
    static let colorForDiaper = themed(light: .OrangeDark, dark: .peach)
    static let colorForMeal = themed(light: .greenSea, dark: .pastelGreen)
    static let colorForSleep = themed(light: .dodgerBlue, dark: .lightBlue)
}

private func themed(light: UIColor, dark: UIColor) -> UIColor {
    return UIColor(dynamicProvider: { trait -> UIColor in
        (trait.userInterfaceStyle == .dark) ? dark : light
    })
}
