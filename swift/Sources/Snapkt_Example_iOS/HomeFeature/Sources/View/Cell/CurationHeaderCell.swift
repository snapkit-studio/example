//
//  CurationHeaderCell.swift
//  Feature
//
//  Created by 김재한 on 10/2/25.
//

import Foundation
import UIKit
import Design

public final class CurationHeaderCell: UICollectionViewCell {
    public let titleLabel: TypographyLabel = {
        let label = TypographyLabel(typography: .head, color: Colors.headTitleColor)
        return label
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(title: String) {
        titleLabel.text = title
    }
    
    private func setUpView() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }
    }
}
