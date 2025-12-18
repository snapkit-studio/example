//
//  Place+Presentation.swift
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

public struct PlacePresentation: Sendable, Hashable {
    var place: Place
    var options: TransformOptions
    
    public init(place: Place, options: TransformOptions) {
        self.place = place
        self.options = options
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(place)
    }
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.place == rhs.place
    }
}

extension Place {
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

