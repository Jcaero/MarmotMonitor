//
//  SceneDelegate.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 18/11/2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
//        let home = TabBar()
//        let home = NameController()
        let home = WelcomeController()
       let navController = UINavigationController(rootViewController: home)
        window?.rootViewController = navController
//        window?.rootViewController?.view.backgroundColor = .white
        window?.makeKeyAndVisible()

    }
}
