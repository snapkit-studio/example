//
//  Place.swift
//  Domain
//
//  Created by 김재한 on 9/30/25.
//

import Foundation

public struct Place: Hashable, Sendable {
    public let id: Int?
    public let endedAt: Date?
    public let imageURL: URL?
    public var imageData: Data?
    public let participantCount: Int?
    public let tags: [String]
    public let title: String

    public init(
        id: Int?,
        endedAt: Date?,
        imageURL: URL?,
        participantCount: Int?,
        tags: [String],
        title: String
    ) {
        self.id = id
        self.endedAt = endedAt
        self.imageURL = imageURL
        self.participantCount = participantCount
        self.tags = tags
        self.title = title
    }
}
