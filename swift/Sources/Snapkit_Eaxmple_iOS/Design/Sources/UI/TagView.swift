//
//  TagView.swift
//  Design
//
//  Created by 김재한 on 10/1/25.
//

import Foundation
import UIKit
import SnapKit

public class TagView: UIView {
    
    public override var intrinsicContentSize: CGSize {
        CGSize(width: titleLabel.intrinsicContentSize.width + Metrics.horizontalMargin * 2,
               height: titleLabel.intrinsicContentSize.height)
    }
    
    private enum Metrics {
        static let horizontalMargin: CGFloat = 8
    }
    
    private let titleLabel: TypographyLabel = {
        let label = TypographyLabel()
        label.textColor = Colors.Category.textColor
        return label
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(text: String) {
        titleLabel.text = text
    }
    
    private func setUpView() {
        addSubview(titleLabel)
        layer.cornerRadius = 4
        backgroundColor = Colors.TagButton.backgroundColor
        titleLabel.snp.makeConstraints { make in
            make.directionalVerticalEdges.equalToSuperview().inset(4)
            make.directionalHorizontalEdges.equalToSuperview().inset(Metrics.horizontalMargin)
        }
    }
}
