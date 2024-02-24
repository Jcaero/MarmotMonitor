//
//  BackgroundViewController.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 04/12/2023.
//

import UIKit

/// Controller for the background view
/// This view is the background of all the other views
/// It's a gradient view that goes from a color to another : blue or pink depending on gender
/// It's also the place where the navigation bar is configured

class BackgroundViewController: UIViewController {
    // MARK: - Propriete
    private let userDefaultsManager = UserDefaultsManager()

    // MARK: - Cycle life
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradient()

        initNavigationBar()
    }

    override func viewWillAppear(_ animated: Bool) {
        setupGradient()
    }

    // MARK: - function
    private func setupGradient() {
        view.layer.sublayers?.first { $0 is CAGradientLayer }?.removeFromSuperlayer()

        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        let gender = userDefaultsManager.getGender()
        if gender == .girl {
            gradient.colors = [UIColor.colorForGradientStartPink.cgColor, UIColor.colorForGradientEnd.cgColor]
        } else {
            gradient.colors = [UIColor.colorForGradientStart.cgColor, UIColor.colorForGradientEnd.cgColor]
        }
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
        navigationController?.navigationBar.tintColor = .colorForLabelBlackToBlue

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactScrollEdgeAppearance = appearance
    }
}
