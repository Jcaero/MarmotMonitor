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
    static let pastelBrown = UIColor(red: 0.75, green: 0.65, blue: 0.56, alpha: 1.00)
    static let darkBrown = UIColor(red: 0.65, green: 0.52, blue: 0.40, alpha: 1.00)
    static let mediumBrown = UIColor(red: 0.58, green: 0.42, blue: 0.27, alpha: 1.00)

    static let heavyBrown = UIColor(red: 0.34, green: 0.14, blue: 0.10, alpha: 1.00)
    static let heavySoftBrown = UIColor(red: 0.55, green: 0.35, blue: 0.31, alpha: 1.00)

    static let dynamicColorForGradientStart = UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ? UIColor.heavyBrown : UIColor.mediumBrown
        }
    static let dynamicColorForGradientEnd = UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ? UIColor.heavySoftBrown : UIColor.pastelBrown
        }
    static let dynamicColorForStokNextButton = UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ? UIColor.black : UIColor.white
        }
    static let dynamicColorForPastelArea = UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ? UIColor.mediumBrown : UIColor.pastelBrown
        }
}
