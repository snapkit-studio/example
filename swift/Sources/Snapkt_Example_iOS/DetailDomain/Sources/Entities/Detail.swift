//
//  Detail.swift
//  Domain
//
//  Created by 김재한 on 9/30/25.
//

import Foundation

public struct Detail: Hashable, Sendable {
    public let description: String
    public let imageURLs: [URL]
    public let isParticipated: Bool
    public let location: String
    public let locationOpeningHourInfo: String
    public let recommendCTAText: String
    public let recommendDescription: String
    public let recommendTitle: String
    public let startAt: Date?
    public let endAt: Date?
    public let title: String
    
    public init(
        description: String,
        imageURLs: [URL],
        isParticipated: Bool,
        location: String,
        locationOpeningHourInfo: String,
        recommendCTAText: String,
        recommendDescription: String,
        recommendTitle: String,
        startAt: Date?,
        endAt: Date?,
        title: String
    ) {
        self.description = description
        self.imageURLs = imageURLs
        self.isParticipated = isParticipated
        self.location = location
        self.locationOpeningHourInfo = locationOpeningHourInfo
        self.recommendCTAText = recommendCTAText
        self.recommendDescription = recommendDescription
        self.recommendTitle = recommendTitle
        self.startAt = startAt
        self.endAt = endAt
        self.title = title
    }
}
