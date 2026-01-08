//
//  AppCoordinator.swift
//  Nrise
//
//  Created by 김재한 on 10/3/25.
//

import Foundation
import UIKit
import Coordinator
import Data
import CoreDomain
import HomeDomain
import HomeFeature

final class AppCoordinator: Coordinator {
    var parent: (any Coordinator)?
    var childs: [any Coordinator] = []
    var window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        let navigationController = UINavigationController()
        let coordinator = MainTabBarCoordinator(navigationController: navigationController)
        store(coordinator)
        window.rootViewController = navigationController
        coordinator.start()
    }
}

