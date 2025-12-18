//
//  HomeCoordinator.swift
//  HomeFeature
//
//  Created by 김재한 on 10/3/25.
//

import Foundation
import Coordinator
import UIKit
import DetailFeatureInterface
import RxSwift

public enum HomeRoute {
    case detail
}

@MainActor
public final class HomeCoordinator: Coordinator {
    public var parent: (any Coordinator)?
    public var childs: [any Coordinator] = []
    private let navigationController: UINavigationController
    private let homeViewController: HomeViewController
    private var disposeBag = DisposeBag()
    
    public init(
        navigationController: UINavigationController,
        homeViewController: HomeViewController,
        detailBuilder: DetailBuildable,
    ) {
        self.navigationController = navigationController
        self.homeViewController = homeViewController
        homeViewController.reactor?
            .route
            .subscribe(onNext: { [weak self] route in
                switch route {
                case .detail:
                    let coordinator = detailBuilder.makeDetailCoordinator(navigationController: navigationController)
                    coordinator.start()
                    self?.store(coordinator)
                }
            }).disposed(by: disposeBag)
    }
    
    public func start() {
        navigationController.pushViewController(homeViewController, animated: true)
    }
    
    deinit {
        Task { @MainActor [weak self] in
            guard let self = self else { return }
            parent?.free(self)
        }
    }
}

