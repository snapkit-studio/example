//
//  TagsResponseModel.swift
//  Data
//
//  Created by 김재한 on 9/30/25.
//

import Foundation

public struct TagsResponseModel: Codable, Sendable {
    let tags: [String]
    
    enum CodingKeys: String, CodingKey {
        case tags = "items"
    }
}
