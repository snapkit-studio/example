//
//  DetailResponseModel.swift
//  Data
//
//  Created by 김재한 on 9/30/25.
//

import Foundation

public struct DetailResponseModel: Codable, Sendable {
    let description: String
    let endAt: String?
    let images: [String]
    let isParticipated: Bool
    let location: String
    let locationOpeningHourInfo: String
    let recommendCTAText: String
    let recommendDescription: String
    let recommendTitle: String
    let startAt: String?
    let title: String

    enum CodingKeys: String, CodingKey {
        case description
        case endAt = "end_at"
        case images
        case isParticipated = "is_participated"
        case location
        case locationOpeningHourInfo = "location_opening_hour_info"
        case recommendCTAText = "recommend_cta_text"
        case recommendDescription = "recommend_description"
        case recommendTitle = "recommend_title"
        case startAt = "start_at"
        case title
    }
}
