//
//  BannerResponse.swift
//  Data
//
//  Created by 김재한 on 9/30/25.
//

import Foundation

public struct BannerResponseModel: Codable, Sendable {
    let bannerMessage: String
    
    enum CodingKeys: String, CodingKey {
        case bannerMessage = "banner_message"
    }
}
