//
//  CurationInfo+Presentation.swift
//  HomeFeature
//
//  Created by 김재한 on 12/18/25.
//

import Foundation
import HomeDomain
@preconcurrency
import snapkit_image
import Design
import UIKit

public struct CurationInfoPresentation: Sendable, Hashable {
    var info: CurationInfo
    var options: TransformOptions
    
    public init(info: CurationInfo, options: TransformOptions) {
        self.info = info
        self.options = options
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(info)
    }
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.info == rhs.info
    }
}

extension CurationInfo {
    private var daysLeft: Int? {
        guard let end = endedAt else { return nil }
        let now = Date()
        guard end >= now else { return nil }
        let calendar = Calendar.current
        let startOfToday = calendar.startOfDay(for: now)
        let startOfEndDay = calendar.startOfDay(for: end)
        return calendar.dateComponents([.day], from: startOfToday, to: startOfEndDay).day
    }

    public var dDay: String {
        let remaining = daysLeft ?? 0
        return "D-\(max(0, remaining))"
    }
    public var dDayTitle: String? {
        guard let remaining = daysLeft else { return title }
        if remaining <= 30 {
            return "\(dDay) \(title)"
        } else {
            return title
        }
    }
}
