//
//  MainTabBarViewController.swift
//  Snapkit_Eaxmple_iOS
//
//  Created by 김재한 on 12/16/25.
//

import UIKit

final class MainTabBarViewController: UITabBarController {

    // MARK: - Initializers
    /// Inject an array of view controllers to be used as tabs.
    init(tabs: [UIViewController]) {
        super.init(nibName: nil, bundle: nil)
        self.viewControllers = tabs
    }

    /// Convenience initializer to inject tab configurations via builders.
    convenience init(buildTabs: () -> [UIViewController]) {
        self.init(tabs: buildTabs())
    }

    @available(*, unavailable, message: "Use init(tabs:) or init(buildTabs:) to inject tabs externally.")
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented. Use init(tabs:) or init(buildTabs:)")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Additional appearance customization can go here if needed.
    }
}
