//
//  Colors.swift
//  Design
//
//  Created by 김재한 on 10/1/25.
//

import Foundation
import UIKit

private enum ColorPrimitives {
    static let black = UIColor(white: 0.0, alpha: 1)
    static let white = UIColor(white: 1.0, alpha: 1)
    static let gray067 = UIColor(white: 0.067, alpha: 1)
    static let gray188 = UIColor(white: 0.188, alpha: 1)
    static let gray350 = UIColor(white: 0.35, alpha: 1)
    static let gray500 = UIColor(white: 0.5, alpha: 1)
    static let gray965 = UIColor(white: 0.965, alpha: 1)
    static let gray890 = UIColor(red: 0.89, green: 0.89, blue: 0.89, alpha: 1)

    static let bluePrimary = UIColor(red: 0.337, green: 0.42, blue: 0.973, alpha: 1)
}

public enum Colors {
    public static let black = ColorPrimitives.black
    public static let buttonTextColor = ColorPrimitives.gray188
    public static let headTitleColor = ColorPrimitives.black
    public static let subTitleColor = ColorPrimitives.gray067
    public static let bodyTextColor = ColorPrimitives.gray350
    public enum Category {
        public static let textColor = ColorPrimitives.gray188
    }
    public enum TagButton {
        public static let backgroundColor = ColorPrimitives.gray965
        public static let textColor = ColorPrimitives.gray500
        public static let selectBackgroundColor = ColorPrimitives.gray188
        public static let selecteTextColor = ColorPrimitives.white
        public static let layerColor = ColorPrimitives.gray890
    }
    public static let dDayTextColor = ColorPrimitives.bluePrimary
    public static let participantTextColor = ColorPrimitives.gray500
    public static let dividerColor = ColorPrimitives.gray965
    public static let backgroundColor = ColorPrimitives.gray965
    public static let white = ColorPrimitives.white
    public static let layerColor = ColorPrimitives.gray890
}
