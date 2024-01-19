//
//  UIViewController+.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 19/01/2024.
//

import UIKit
extension UIViewController {
    func showSimpleAlerte(with titre: String, message: String) {
        let alertVC = UIAlertController(title: titre, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        return self.present(alertVC, animated: true, completion: nil)
    }
}
