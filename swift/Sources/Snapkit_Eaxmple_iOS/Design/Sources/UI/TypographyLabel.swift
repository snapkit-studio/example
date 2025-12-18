//
//  TypographyLabel.swift
//  Design
//
//  Created by 김재한 on 10/1/25.
//

import Foundation
import UIKit

public final class TypographyLabel: UILabel {
    
    override public var text: String? {
        didSet {
            setStyledText(text ?? "", using: typography, color: color)
        }
    }
    
    override public var textColor: UIColor! {
        didSet {
            setStyledText(text ?? "", using: typography, color: textColor)
        }
    }
    
    public override var lineBreakMode: NSLineBreakMode {
        didSet {
            setStyledText(text ?? "", using: typography, color: color)
        }
    }
    
    private let typography: Typography
    private let color: UIColor
    
    public init(
        text: String? = nil,
        typography: Typography? = .body,
        color: UIColor? = Colors.bodyTextColor
    ) {
        self.typography = typography ?? .body
        self.color = color ?? .black
        super.init(frame: .zero)
        setStyledText(text ?? "", using: typography ?? .body, color: color ?? .black)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func setStyledText(
        _ text: String,
        using typography: Typography,
        color: UIColor,
        alignment: NSTextAlignment = .left,
        additionalAttributes: [NSAttributedString.Key: Any] = [:]
    ) {
        var attributes = typography.attributes
        let paragraphStyle = (typography.attributes[.paragraphStyle] as? NSMutableParagraphStyle) ?? NSMutableParagraphStyle()
        paragraphStyle.alignment = alignment
        paragraphStyle.lineBreakMode = lineBreakMode

        attributes[.paragraphStyle] = paragraphStyle
        attributes[.foregroundColor] = color

        let mergedAttributes = attributes.merging(additionalAttributes, uniquingKeysWith: { _, rhs in rhs })
        self.attributedText = NSAttributedString(string: text, attributes: mergedAttributes)
    }
    
    public func setHighlight(with text: String, using color: UIColor?) {
        guard !text.isEmpty, let current = self.attributedText else { return }

        let fullString = current.string as NSString
        let mutable = NSMutableAttributedString(attributedString: current)

        var searchRange = NSRange(location: 0, length: fullString.length)

        while true {
            let foundRange = fullString.range(of: text, options: [.caseInsensitive], range: searchRange)
            if foundRange.location == NSNotFound { break }
            mutable.addAttribute(.foregroundColor, value: color ?? .red, range: foundRange)
            let nextLocation = foundRange.location + foundRange.length
            searchRange = NSRange(location: nextLocation, length: fullString.length - nextLocation)
        }

        self.attributedText = mutable
    }
}
