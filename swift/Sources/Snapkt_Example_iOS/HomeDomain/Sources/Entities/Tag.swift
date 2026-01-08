//
//  Tag.swift
//  Domain
//
//  Created by 김재한 on 9/30/25.
//

import Foundation

public struct Tag: Hashable, Sendable {
    public let name: String
    
    public init(name: String) {
        self.name = name
    }
}
