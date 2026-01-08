//
//  HomeCategoryCell.swift
//  Feature
//
//  Created by 김재한 on 10/2/25.
//

import UIKit
import SnapKit
import HomeDomain

public final class HomeCategoryCell: UICollectionViewCell {

    private let containerView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fillEqually
        return view
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(model: [HomeCategoryPresentation]) {
        model.forEach { category in
            let categoryView = CategoryView()
            categoryView.configure(model: category)
            containerView.addArrangedSubview(categoryView)
        }
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        containerView.subviews.forEach {
            $0.removeFromSuperview()
        }
    }
    
    private func setUpView() {
        addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.verticalEdges.equalToSuperview()
        }
    }
}
