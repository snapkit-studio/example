//
//  DetailFeatureInterface.swift
//  DetailFeatureInterface
//
//  Created by 김재한 on 10/3/25.
//

import Foundation
import Coordinator
import UIKit

@MainActor
public protocol DetailBuildable: AnyObject {
    func makeDetailCoordinator(
        navigationController: UINavigationController
    ) -> any Coordinator
}
