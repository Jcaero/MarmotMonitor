//
//  FoodTapBar.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 14/12/2023.
//

import Foundation
import UIKit

class FoodTapBar: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVCs()
        setupTabBar()
    }

    func setupVCs() {
        let breastController = UINavigationController(rootViewController: BreastFeedingController())
        let bottleController = UINavigationController(rootViewController: BottleFeedingController())
        let solidController = UINavigationController(rootViewController: SolideFeedingController())

        breastController.tabBarItem = UITabBarItem(title: "Tétée", image: UIImage(systemName: "figure.child"), tag: 0)
        breastController.tabBarItem.accessibilityHint = "appuyer pour afficher l'allaitement"

        bottleController.tabBarItem = UITabBarItem(title: "Biberon", image: UIImage(systemName: "waterbottle"), tag: 1)
        bottleController.tabBarItem.accessibilityHint = "appuyer pour afficher le biberon"

        solidController.tabBarItem = UITabBarItem(title: "Solides", image: UIImage(systemName: "fork.knife"), tag: 2)
        solidController.tabBarItem.accessibilityHint = "appuyer pour afficher la nourriture solide"

        viewControllers = [breastController, bottleController, solidController]
    }

    func setupTabBar() {

        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .none

        // setup normal Attributes
        let normalAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.gray,
            .font: UIFont(name: "Symbol", size: 17)!
        ]

        // setup selected Attributes
        let selectedAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.duckBlue]

        appearance.stackedLayoutAppearance.normal.titleTextAttributes = normalAttributes
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = selectedAttributes

        appearance.stackedLayoutAppearance.normal.iconColor = .gray
        appearance.stackedLayoutAppearance.selected.iconColor = .duckBlue

        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = tabBar.standardAppearance

    }
}
