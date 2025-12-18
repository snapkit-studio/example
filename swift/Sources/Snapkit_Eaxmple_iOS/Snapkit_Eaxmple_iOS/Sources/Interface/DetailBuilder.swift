//
//  DetailBuilder.swift
//  Nrise
//
//  Created by 김재한 on 10/3/25.
//

import Foundation
import Data
import DetailDomain
import DetailFeature
import Coordinator
import DetailFeatureInterface
import UIKit

public final class SnapkitDetailBuilder: DetailBuildable {
    public init() {}
    
    public func makeDetailCoordinator(navigationController: UINavigationController) -> any Coordinator {
        let networkService = MockNetworkServiceProvider()
        let repository = DetailRepositoryImpl(networkService: networkService)
        let useCase = DetailUseCaseImpl(repository: repository)
        let reactor = DetailReactor(useCase: useCase, mapper: SnapkitDetailPresentationMapper())
        let viewController = DetailViewController(reactor: reactor)
        return DetailCoordinator(navigationController: navigationController, viewController: viewController)
    }
}

public final class OriginalDetailBuilder: DetailBuildable {
    public init() {}
    
    public func makeDetailCoordinator(navigationController: UINavigationController) -> any Coordinator {
        let networkService = OriginalMockserviceProvider()
        let repository = DetailRepositoryImpl(networkService: networkService)
        let useCase = DetailUseCaseImpl(repository: repository)
        let reactor = DetailReactor(useCase: useCase, mapper: OriginalDetailPresentationMapper())
        let viewController = DetailViewController(reactor: reactor)
        return DetailCoordinator(navigationController: navigationController, viewController: viewController)
    }
}
