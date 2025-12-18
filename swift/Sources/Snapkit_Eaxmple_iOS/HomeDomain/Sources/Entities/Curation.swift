//
//  Curation.swift
//  Domain
//
//  Created by 김재한 on 9/30/25.
//

import Foundation

public struct Curation: Hashable, Sendable {
    public let title: String
    public var info: [CurationInfo]

    public init(title: String, info: [CurationInfo]) {
        self.title = title
        self.info = info
    }
}

public struct CurationInfo: Hashable, Sendable {
    public let title: String
    public let imageURL: URL?
    public var imageData: Data?
    public let tags: [String]
    public let participantCount: Int?
    public let endedAt: Date?
    
    public init(
        title: String,
        imageURL: URL?,
        tags: [String],
        participantCount: Int?,
        endedAt: Date?
    ) {
        self.title = title
        self.imageURL = imageURL
        self.tags = tags
        self.participantCount = participantCount
        self.endedAt = endedAt
    }
}
