//
//  CategoryResponse.swift
//  Data
//
//  Created by 김재한 on 9/30/25.
//

import Foundation

public struct CategoryResponseModel: Codable, Sendable {
    let cotegories: [Category]
    
    struct Category: Codable, Sendable {
        let imageURL: String
        let title: String
        
        enum CodingKeys: String, CodingKey {
            case imageURL = "image_url"
            case title
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case cotegories = "items"
    }
}
