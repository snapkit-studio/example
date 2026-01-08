//
//  Typography.swift
//  Design
//
//  Created by 김재한 on 10/1/25.
//

import Foundation
import UIKit

public struct Typography: Sendable {
    public let size: CGFloat
    public let lineHeight: CGFloat
    public let weight: UIFont.Weight

    public var attributes: [NSAttributedString.Key: Any] {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = lineHeight
        paragraphStyle.maximumLineHeight = lineHeight

        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: size, weight: weight),
            .paragraphStyle: paragraphStyle
        ]

        return attributes
    }
}

public extension Typography {
    static let caption = Typography(size: 12, lineHeight: 18, weight: .regular)
    static let captionBold = Typography(size: 12, lineHeight: 18, weight: .bold)

    static let body = Typography(size: 14, lineHeight: 19, weight: .regular)
    static let bodyBold = Typography(size: 14, lineHeight: 19, weight: .bold)

    static let head = Typography(size: 20, lineHeight: 21, weight: .regular)
    static let bold = Typography(size: 20, lineHeight: 21, weight: .bold)
}
