//
//  CurationsResponseModel.swift
//  Data
//
//  Created by 김재한 on 9/30/25.
//

import Foundation

public struct CurationsResponseModel: Codable, Sendable {
    let curations: [Curation]
    
    struct Curation: Codable, Sendable {
        let title: String
        let items: [Item]
    }
    
    struct Item: Codable, Sendable {
        let imageURL: String
        let title: String
        let tags: [String]
        let participantCount: Int?
        let endedAt: String?
        
        enum CodingKeys: String, CodingKey {
            case imageURL = "image_url"
            case title
            case tags
            case participantCount = "participant_count"
            case endedAt = "ended_at"
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case curations = "items"
    }
}
