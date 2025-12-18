//
//  PresentationMapper.swift
//  DetailFeature
//
//  Created by 김재한 on 12/18/25.
//

import Foundation
import DetailDomain
import snapkit_image
import UIKit

public protocol PresentationMappale {
    func transform(from: URL) -> DetailPresentation
}

public struct OriginalDetailPresentationMapper: PresentationMappale {
    
    public init() {
        
    }
    
    public func transform(from: URL) -> DetailPresentation {
        DetailPresentation(
            url: from,
            options: TransformOptions()
        )
    }
}


public struct SnapkitDetailPresentationMapper: PresentationMappale {
    
    public init() {
        
    }
    
    public func transform(from: URL) -> DetailPresentation {
        DetailPresentation(
            url: from,
            options: TransformOptions()
                .setWidth(Int(UIScreen.main.bounds.width))
                .setFormat(.webp)
                .setDPR(2.0)
        )
    }
}
