//
//  BackgroundViewController.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 04/12/2023.
//

import UIKit

class BackgroundViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradient()

        initNavigationBar()
    }

    private func setupGradient() {
        view.layer.sublayers?.first { $0 is CAGradientLayer }?.removeFromSuperlayer()

        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [UIColor.colorForGradientStart.cgColor, UIColor.colorForGradientEnd.cgColor]
        gradient.locations = [0.0, 1.0]
        view.layer.insertSublayer(gradient, at: 0)
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if self.traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            setupGradient()
        }
    }

    private func initNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .clear

        navigationItem.backButtonDisplayMode = .minimal
        navigationController?.navigationBar.tintColor = .colorForLabelBlackToBrown

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactScrollEdgeAppearance = appearance
    }
}
