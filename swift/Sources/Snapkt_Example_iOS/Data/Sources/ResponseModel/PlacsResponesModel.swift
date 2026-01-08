//
//  PlacsResponesModel.swift
//  Data
//
//  Created by 김재한 on 9/30/25.
//

import Foundation

public struct PlacesResponseModel: Codable, Sendable {
    let place: [Place]
    
    public struct Place: Codable, Sendable {
        let id: Int?
        let endedAt: String?
        let imageURL: String
        let participantCount: Int?
        let tags: [String]
        let title: String
        
        enum CodingKeys: String, CodingKey {
            case id
            case endedAt = "ended_at"
            case imageURL = "image_url"
            case participantCount = "participant_count"
            case tags
            case title
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case place = "items"
    }
}
