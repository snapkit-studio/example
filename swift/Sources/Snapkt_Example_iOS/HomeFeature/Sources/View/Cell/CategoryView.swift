//
//  CategoryView.swift
//  Feature
//
//  Created by 김재한 on 10/2/25.
//

import Foundation
import UIKit
import Design
import CoreDomain
import snapkit_image
import HomeDomain

public final class CategoryView: UIView {
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
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
    
    public func configure(model: HomeCategoryPresentation) {
        Task { [weak self] in
            let image = try? await ImageDownloader.shared.downloadImage(
                from: TransformQueryBuilder(url: model.homeCategory.imageURL)
                    .buildTransformURL(
                        options: model.options
                    )
            )
            self?.imageView.image = image
        }
        titleLabel.text = model.homeCategory.title
    }
    
    private func setUpView() {
        addSubview(imageView)
        addSubview(titleLabel)
        imageView.snp.makeConstraints { make in
            make.top.equalTo(20)
            make.centerX.equalToSuperview()
            make.size.equalTo(24)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(4)
            make.bottom.equalToSuperview().inset(20)
            make.centerX.equalToSuperview()
        }
    }
}

