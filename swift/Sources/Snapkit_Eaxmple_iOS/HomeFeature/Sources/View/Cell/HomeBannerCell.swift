//
//  HomeBannerCell.swift
//  Feature
//
//  Created by 김재한 on 10/2/25.
//

import Foundation
import UIKit
import HomeDomain

public class HomeBannerCell: UICollectionViewCell {
    private let bannerView = BannerView()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    public func configure(banner: Banner) {
        bannerView.configure(text: banner.message)
    }
    
    private func setUpView() {
        addSubview(bannerView)
        bannerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
