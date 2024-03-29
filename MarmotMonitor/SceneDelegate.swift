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

        let savedName = UserDefaults.standard.string(forKey: UserInfoKey.babyName.rawValue)
        print("savedName: \(String(describing: savedName))")
        let home = savedName != nil ? TabBarController() : UINavigationController(rootViewController: WelcomeController())

        let navController = home
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
    }
}
