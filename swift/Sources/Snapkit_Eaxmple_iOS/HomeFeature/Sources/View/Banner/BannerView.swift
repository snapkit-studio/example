//
//  BannerView.swift
//  Feature
//
//  Created by 김재한 on 10/2/25.
//

import Foundation
import Design
import UIKit
import SnapKit

public class BannerView: UIView {
    private let imageView = UIImageView(image: Icons.notice)
    private let titleLabel: TypographyLabel = {
        let label = TypographyLabel(typography: .bodyBold, color: Colors.headTitleColor)
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
        addSubview(imageView)
        addSubview(titleLabel)
        backgroundColor = Colors.backgroundColor
        imageView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(16)
            make.leading.equalToSuperview().inset(16)
            make.size.equalTo(24)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(imageView.snp.trailing).offset(8)
            make.trailing.equalToSuperview().inset(16)
        }
    }
}
