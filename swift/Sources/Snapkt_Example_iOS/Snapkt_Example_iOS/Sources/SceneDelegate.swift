//
//  SceneDelegate.swift
//  Nrise
//
//  Created by 김재한 on 9/29/25.
//

import UIKit
import Data
import HomeDomain
import HomeFeature

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var coordinator: AppCoordinator?
    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }

        let window = UIWindow(windowScene: windowScene)
        window.backgroundColor = .systemBackground
        coordinator = AppCoordinator(window: window)
        coordinator?.start()
        window.makeKeyAndVisible()
    }
}
