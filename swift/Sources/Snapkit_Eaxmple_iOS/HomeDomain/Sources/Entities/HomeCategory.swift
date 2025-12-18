//
//  Category.swift
//  Domain
//
//  Created by 김재한 on 9/30/25.
//

import Foundation

public struct HomeCategory: Hashable, Sendable {
    public let imageURL: URL?
    public let title: String

    public init(imageURL: URL?, title: String) {
        self.imageURL = imageURL
        self.title = title
    }
}
