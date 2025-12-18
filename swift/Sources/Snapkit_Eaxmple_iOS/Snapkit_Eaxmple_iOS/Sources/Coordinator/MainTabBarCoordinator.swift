//
//  MainTabBarCoordinator.swift
//  Snapkit_Eaxmple_iOS
//
//  Created by 김재한 on 12/16/25.
//

import Foundation
import UIKit
import Coordinator
import Data
import CoreDomain
import HomeDomain
import HomeFeature

final class MainTabBarCoordinator: Coordinator {
    var parent: (any Coordinator)?
    var childs: [any Coordinator] = []
    
    private let navigationController: UINavigationController
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let originalHomeViewController = HomeViewController(
            reactor: HomeReactor(
                useCase: HomeUseCaseImpl(
                    homeRepository: HomeRepositoryImpl(
                        networkService: MockNetworkServiceProvider()
                    )
                ),
                mapper: OriginalHomePresentationMapper()
            )
        )
        let snapkitHomeViewController = HomeViewController(
            reactor: HomeReactor(
                useCase: HomeUseCaseImpl(
                    homeRepository: HomeRepositoryImpl(
                        networkService: MockNetworkServiceProvider()
                    )
                ),
                mapper: SnapkitHomePresentationMapper()
            )
        )
        let originalHomeCoordinator = HomeCoordinator(
            navigationController: navigationController,
            homeViewController: originalHomeViewController,
            detailBuilder: OriginalDetailBuilder()
        )
        let snapkitHomeCoordinator = HomeCoordinator(
            navigationController: navigationController,
            homeViewController: snapkitHomeViewController,
            detailBuilder: SnapkitDetailBuilder()
        )
        
        let tabBar = MainTabBarViewController {
            let original = originalHomeViewController
            original.tabBarItem = UITabBarItem(title: "Original", image: UIImage(systemName: "circle"), selectedImage: UIImage(systemName: "circle.fill"))

            let snapkit = snapkitHomeViewController
            snapkit.tabBarItem = UITabBarItem(title: "Snapkit", image: UIImage(systemName: "square"), selectedImage: UIImage(systemName: "square.fill"))
            return [original, snapkit]
        }
        
        store(originalHomeCoordinator)
        store(snapkitHomeCoordinator)
        
        navigationController.pushViewController(tabBar, animated: true)
    }
}
