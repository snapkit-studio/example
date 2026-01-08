//
//  Detail+Presentation.swift
//  DetailFeature
//
//  Created by 김재한 on 10/3/25.
//

import Foundation
import DetailDomain
@preconcurrency
import snapkit_image

public struct DetailPresentation: Hashable, Sendable {
    var url: URL
    var options: TransformOptions
    
    public init(url: URL, options: TransformOptions) {
        self.url = url
        self.options = options
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(url)
    }
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.url == rhs.url
    }
}

public extension Detail {
    var period: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = .current
        formatter.dateFormat = "yyyy년 MM월 dd일"
        
        func format(_ date: Date) -> String { formatter.string(from: date) }
        
        switch (startAt, endAt) {
        case let (start?, end?):
            return "기간 \(format(start)) ~ \(format(end))"
        case let (start?, nil):
            return "기간 \(format(start)) ~"
        case let (nil, end?):
            return "기간 ~ \(format(end))"
        default:
            return "기간"
        }
    }
}
