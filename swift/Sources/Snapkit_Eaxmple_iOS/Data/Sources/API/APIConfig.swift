//
//  APIConfig.swift
//  Data
//
//  Created by 김재한 on 9/30/25.
//

import Foundation

public enum APIConfig {
    case banner
    case categories
    case curations
    case tags
    case place(String)
    case detail
}

extension APIConfig {
    var snapkitPath: String {
        return switch self {
            case .banner: "banner"
            case .categories: "categories"
            case .curations: "curations"
            case .tags: "tags"
            case .place(let id): "place\(id)"
            case .detail: "detail"
        }
    }
    
    var path: String {
        return switch self {
            case .banner: "banner_original"
            case .categories: "categories_original"
            case .curations: "curations_original"
            case .tags: "tags_original"
            case .place(let id): "place\(id)_original"
            case .detail: "detail_original"
        }
    }
    
    var method: String {
        "GET"
    }
}
