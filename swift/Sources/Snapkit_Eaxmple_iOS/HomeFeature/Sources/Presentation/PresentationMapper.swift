//
//  PresentationMapper.swift
//  HomeFeature
//
//  Created by 김재한 on 12/18/25.
//

import Foundation
import HomeDomain
import snapkit_image

public protocol PresentationMappale {
    func transform(from: CurationInfo) -> CurationInfoPresentation
    func transform(from: [HomeCategory]) -> [HomeCategoryPresentation]
    func transform(from: Place) -> PlacePresentation
}

public struct OriginalHomePresentationMapper: PresentationMappale {
    
    public init() {}
    
    public func transform(from: CurationInfo) -> CurationInfoPresentation {
        return CurationInfoPresentation(info: from, options: TransformOptions())
    }
    
    public func transform(from: [HomeCategory]) -> [HomeCategoryPresentation] {
        return from.map { category in
            HomeCategoryPresentation(homeCategory: category, options: TransformOptions())
        }
    }
    
    public func transform(from: Place) -> PlacePresentation {
        return PlacePresentation(place: from, options: TransformOptions())
    }
}

public struct SnapkitHomePresentationMapper: PresentationMappale {
    
    public init() {}
    
    public func transform(from: CurationInfo) -> CurationInfoPresentation {
        return CurationInfoPresentation(
            info: from,
            options: TransformOptions()
                .setWidth(195)
                .setDPR(2.0)
                .setFormat(.webp)
        )
    }
    
    public func transform(from: [HomeCategory]) -> [HomeCategoryPresentation] {
        return from.map { category in
            HomeCategoryPresentation(
                homeCategory: category,
                options: TransformOptions()
                    .setWidth(95)
                    .setDPR(2.0)
                    .setFormat(.webp)
            )
        }
    }
    
    public func transform(from: Place) -> PlacePresentation {
        return PlacePresentation(
            place: from,
            options: TransformOptions()
                .setHeight(148)
                .setDPR(2.0)
                .setFormat(.webp)
        )
    }
}
