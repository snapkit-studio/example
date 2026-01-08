//
//  NavigationView.swift
//  Design
//
//  Created by 김재한 on 10/3/25.
//

import Foundation
import UIKit

public final class NavigationView: UIView {
    private let leftIcon: UIImageView = {
        let imageView = UIImageView(image: Icons.topNavigationLeft24)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpView() {
        addSubview(leftIcon)
        leftIcon.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(10)
            make.leading.equalToSuperview().inset(16)
        }
    }
}
