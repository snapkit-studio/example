//
//  Coordinator.swift
//  Coordinator
//
//  Created by 김재한 on 10/3/25.
//

import Foundation

@MainActor
public protocol Coordinator: AnyObject {
    var parent: (any Coordinator)? { get set }
    var childs: [any Coordinator] { get set }
    func start()
}

public extension Coordinator {
    func store(_ child: any Coordinator) {
        child.parent = self
        self.childs.append(child)
    }
    
    func free(_ child: any Coordinator) {
        self.childs.removeAll { $0 === child }
    }
}
