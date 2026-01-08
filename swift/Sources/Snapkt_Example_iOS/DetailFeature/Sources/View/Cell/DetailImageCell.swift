//
//  DetailImageCell.swift
//  DetailFeature
//
//  Created by 김재한 on 10/3/25.
//

import Foundation
import UIKit
import Design
import snapkit_image
import CoreDomain

public final class DetailImageCell: UICollectionViewCell {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(model: DetailPresentation) {
        Task { [weak self] in
            let image = try? await ImageDownloader.shared.downloadImage(
                from: TransformQueryBuilder(url: model.url)
                    .buildTransformURL(
                        options: model.options
                    )
            )
            self?.imageView.image = image
        }
    }
    
    private func setUpView() {
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
