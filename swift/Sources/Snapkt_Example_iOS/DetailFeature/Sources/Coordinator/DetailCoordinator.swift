//
//  DetailCoordinator.swift
//  DetailFeature
//
//  Created by 김재한 on 10/3/25.
//

import Foundation
import Coordinator
import UIKit
import RxSwift

public enum DetailRoute {
    case leave
}

public final class DetailCoordinator: Coordinator {
    public var parent: (any Coordinator)?
    public var childs: [any Coordinator] = []
    private let viewController: UIViewController
    private let navigationController: UINavigationController
    private let disposeBag = DisposeBag()
    
    public init(navigationController: UINavigationController, viewController: DetailViewController) {
        self.navigationController = navigationController
        self.viewController = viewController
        viewController.reactor?.route
            .subscribe { [weak self] route in
                guard let self = self else { return }
                parent?.free(self)
                navigationController.popViewController(animated: true)
            }.disposed(by: disposeBag)
    }
    
    public func start() {
        navigationController.pushViewController(viewController, animated: true)
    }
}
