//
//  HomeCategory+Presentation.swift
//  HomeFeature
//
//  Created by 김재한 on 12/18/25.
//

import Foundation
import HomeDomain
@preconcurrency
import snapkit_image

public struct HomeCategoryPresentation: Sendable, Hashable {
    var homeCategory: HomeCategory
    var options: TransformOptions
    
    public init(homeCategory: HomeCategory, options: TransformOptions) {
        self.homeCategory = homeCategory
        self.options = options
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(homeCategory)
    }
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.homeCategory == rhs.homeCategory
    }
}
