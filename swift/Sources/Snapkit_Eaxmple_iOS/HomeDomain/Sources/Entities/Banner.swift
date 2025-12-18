//
//  Banner.swift
//  Domain
//
//  Created by 김재한 on 9/30/25.
//

import Foundation

public struct Banner: Hashable, Sendable {
    public let message: String

    public init(message: String) {
        self.message = message
    }
}
