//
//  TapBarController.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 18/11/2023.
//

import UIKit

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVCs()
        setupTabBar()
    }

    func setupVCs() {
        let todayController = UINavigationController(rootViewController: TodayViewController())
        let monitorController = UINavigationController(rootViewController: ViewForInformationController())
        let doctorController = UINavigationController(rootViewController: ViewForInformationController())
        let settingsController = UINavigationController(rootViewController: ViewForInformationController())

        todayController.tabBarItem = UITabBarItem(title: "Auj.", image: UIImage(systemName: "calendar"), tag: 0)
        todayController.tabBarItem.accessibilityHint = "appuyer pour afficher la page du jour"

        monitorController.tabBarItem = UITabBarItem(title: "Monitor", image: UIImage(systemName: "waveform.path.ecg"), tag: 1)
        monitorController.tabBarItem.accessibilityHint = "appuyer pour afficher la page de suivie"

        doctorController.tabBarItem = UITabBarItem(title: "Docteur", image: UIImage(systemName: "stethoscope"), tag: 2)
        doctorController.tabBarItem.accessibilityHint = "appuyer pour afficher le prochain rendez vous docteur"

        settingsController.tabBarItem = UITabBarItem(title: "Réglage", image: UIImage(systemName: "gear"), tag: 3)
        settingsController.tabBarItem.accessibilityHint = "appuyer pour afficher les réglages"

        viewControllers = [todayController, monitorController, doctorController, settingsController]
    }

    func setupTabBar() {

        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .none

        // setup normal Attributes
        let normalAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.lightGray,
            .font: UIFont(name: "Courier New", size: 15)!
        ]

        // setup selected Attributes
        let selectedAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.black]

        appearance.stackedLayoutAppearance.normal.titleTextAttributes = normalAttributes
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = selectedAttributes

        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = tabBar.standardAppearance

    }
}
