//
//  DividerCell.swift
//  Feature
//
//  Created by 김재한 on 10/2/25.
//

import Foundation
import UIKit
import Design

public final class DividerCell: UICollectionViewCell {
    public override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Colors.dividerColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
