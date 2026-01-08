//
//  CurationCell.swift
//  Feature
//
//  Created by 김재한 on 10/2/25.
//

import Foundation
import UIKit
import Design
import CoreDomain
import HomeDomain
import snapkit_image
import RxSwift

public final class CurationCell: UICollectionViewCell {
    
    public var disposeBag = DisposeBag()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = Colors.layerColor.cgColor
        return imageView
    }()
    
    private let captionLabel: TypographyLabel = {
        let label = TypographyLabel(
            typography: .captionBold,
            color: Colors.subTitleColor
        )
        return label
    }()
    
    private let tagContainerView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 4
        return view
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(model: CurationInfoPresentation) {
        Task { [weak self] in
            let image = try? await ImageDownloader.shared.downloadImage(
                from: TransformQueryBuilder(url: model.info.imageURL)
                    .buildTransformURL(
                        options: model.options
                    )
            )
            self?.imageView.image = image
        }
        captionLabel.text = model.info.dDayTitle
        captionLabel.setHighlight(with: model.info.dDay, using: Colors.dDayTextColor)
        var visibleWitdh: CGFloat = 0
        for tag in model.info.tags {
            let view = TagView()
            view.configure(text: tag)
            visibleWitdh += view.intrinsicContentSize.width
            if visibleWitdh > frame.width {
                break
            }
            tagContainerView.addArrangedSubview(view)
        }
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        tagContainerView.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }
        disposeBag = DisposeBag()
    }
    
    private func setUpView() {
        contentView.addSubview(imageView)
        contentView.addSubview(captionLabel)
        contentView.addSubview(tagContainerView)
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(260)
        }
        
        captionLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(8)
            make.leading.equalToSuperview()
        }
        
        tagContainerView.snp.makeConstraints { make in
            make.top.equalTo(captionLabel.snp.bottom).offset(4)
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}
