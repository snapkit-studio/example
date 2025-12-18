//
//  PlaceCell.swift
//  Feature
//
//  Created by 김재한 on 10/2/25.
//

import Foundation
import UIKit
import Design
import HomeDomain
import RxSwift
import CoreDomain
import snapkit_image

public final class PlaceCell: UICollectionViewCell {
    
    public var disposeBag = DisposeBag()

    private let tagRowHeight: CGFloat = 28
    private let tagInterItemSpacing: CGFloat = 4
    private let tagInterRowSpacing: CGFloat = 8
    
    private let divider: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.dividerColor
        return view
    }()
    
    private let titleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = Colors.layerColor.cgColor
        return imageView
    }()
    
    private let titleLabel: TypographyLabel = {
        let label = TypographyLabel(typography: .bodyBold, color: Colors.bodyTextColor)
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    private let tagContainerView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 8 // tagInterRowSpacing
        view.alignment = .leading
        view.distribution = .fill
        return view
    }()
    
    private var tagRowStackViews: [UIStackView] = []
    
    private let participantCountImageView: UIImageView = {
        let imageView = UIImageView(image: Icons.heart)
        return imageView
    }()
    
    private let participantCountLabel: TypographyLabel = {
        let label = TypographyLabel()
        label.numberOfLines = 1
        return label
    }()
    
    private let participantContainerView: UIStackView = {
        let view = UIStackView()
        view.alignment = .center
        view.axis = .horizontal
        view.spacing = 4
        return view
    }()
    
    private let contentContainerView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .equalSpacing
        view.spacing = 8
        return view
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
        clearTags()
    }
    
    public override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        setNeedsLayout()
        layoutIfNeeded()

        let targetSize = CGSize(width: layoutAttributes.size.width,
                                height: UIView.layoutFittingCompressedSize.height)
        let size = contentView.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
        layoutAttributes.size.height = ceil(size.height)
        return layoutAttributes
    }
    
    public func configure(model: PlacePresentation) {
        titleLabel.text = model.place.dDayTitle
        titleLabel.setHighlight(with: model.place.dDay, using: Colors.dDayTextColor)
        Task { [weak self] in
            let image = try? await ImageDownloader.shared.downloadImage(
                from: TransformQueryBuilder(url: model.place.imageURL)
                    .buildTransformURL(
                        options: model.options
                    )
            )
            self?.titleImageView.image = image
        }
        participantContainerView.isHidden = (model.place.participantCount == nil) ? true : false
        participantCountLabel.text = "관심 \(String(model.place.participantCount ?? 0))명"
        makeTagView(tags: model.place.tags)
    }
    
    private func makeTagView(tags: [String]) {
        clearTags()
        
        // Fallback estimation based on known constraints: 16 (leading) + 70 (image) + 12 (spacing) + 16 (trailing)
        let estimated = contentView.bounds.width - 114
        let fittingTags = tagsFittingInTwoRows(tags, width: estimated)

        addTagsToStackViews(fittingTags, width: estimated)
    }
    
    private func clearTags() {
        tagRowStackViews.forEach { stackView in
            stackView.removeFromSuperview()
        }
        tagRowStackViews.removeAll()
    }
    
    private func addTagsToStackViews(_ tags: [String], width: CGFloat) {
        guard width > 0, !tags.isEmpty else { return }
        
        var currentRowStackView: UIStackView?
        var currentRowWidth: CGFloat = 0
        var rowCount = 0
        
        for tag in tags {
            let tagWidth = measureTagWidth(for: tag)
            
            // 태그가 전체 너비보다 큰 경우 스킵
            if tagWidth > width { continue }
            
            // 현재 행에 추가했을 때 필요한 너비 계산
            let neededWidth = currentRowWidth == 0 ? tagWidth : (currentRowWidth + tagInterItemSpacing + tagWidth)
            
            // 새로운 행이 필요한지 확인
            let needNewRow = currentRowStackView == nil || neededWidth > width
            
            if needNewRow {
                rowCount += 1
                // 최대 2행까지만 허용
                if rowCount > 2 { break }
                
                // 새로운 horizontal StackView 생성
                let newRowStackView = UIStackView()
                newRowStackView.axis = .horizontal
                newRowStackView.spacing = tagInterItemSpacing
                newRowStackView.alignment = .leading
                newRowStackView.distribution = .fill
                
                // tagContainerView에 새로운 행 추가
                tagContainerView.addArrangedSubview(newRowStackView)
                tagRowStackViews.append(newRowStackView)
                
                // 현재 행 업데이트
                currentRowStackView = newRowStackView
                currentRowWidth = tagWidth
            } else {
                // 기존 행에 추가할 수 있는 경우 너비 업데이트
                currentRowWidth = neededWidth
            }
            
            // TagView 생성하고 현재 행에 추가
            let tagView = TagView()
            tagView.configure(text: tag)
            currentRowStackView?.addArrangedSubview(tagView)
        }
    }
    
    private func measureTagWidth(for text: String) -> CGFloat {
        let tagView = TagView()
        tagView.configure(text: text)
        let size = tagView.intrinsicContentSize
        return ceil(size.width)
    }

    private func tagsFittingInTwoRows(_ tags: [String], width: CGFloat) -> [String] {
        guard width > 0 else { return [] }
        var result: [String] = []
        var currentRowWidth: CGFloat = 0
        var row: Int = 1

        for tag in tags {
            let tagWidth = measureTagWidth(for: tag)
            if tagWidth > width { continue }

            let neededWidth = currentRowWidth == 0 ? tagWidth : (currentRowWidth + tagInterItemSpacing + tagWidth)
            if neededWidth <= width {
                result.append(tag)
                currentRowWidth = neededWidth
            } else {
                row += 1
                if row > 2 {
                    break
                }
                result.append(tag)
                currentRowWidth = tagWidth
            }
        }

        return result
    }
    
    private func setUpView() {
        contentView.addSubview(divider)
        contentView.addSubview(titleImageView)
        contentView.addSubview(contentContainerView)
        contentContainerView.addArrangedSubview(titleLabel)
        contentContainerView.addArrangedSubview(tagContainerView)
        participantContainerView.addArrangedSubview(participantCountImageView)
        participantContainerView.addArrangedSubview(participantCountLabel)
        contentContainerView.addArrangedSubview(participantContainerView)
        
        contentContainerView.setContentCompressionResistancePriority(.required, for: .vertical)
        contentContainerView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        divider.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(1)
        }
        
        titleImageView.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(divider.snp.bottom).offset(16)
            make.bottom.lessThanOrEqualToSuperview().inset(16)
            make.width.equalTo(70)
            make.height.equalTo(96)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(16)
        }
        
        participantCountImageView.snp.makeConstraints { make in
            make.size.equalTo(16)
        }
        
        contentContainerView.snp.makeConstraints { make in
            make.leading.equalTo(titleImageView.snp.trailing).offset(12)
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.top.greaterThanOrEqualTo(divider.snp.bottom).offset(16)
            make.bottom.lessThanOrEqualToSuperview().inset(16)
        }
    }
}


