//
//  FloatingButton.swift
//  HomeFeature
//
//  Created by 김재한 on 10/3/25.
//

import UIKit
import Design

public final class FloatingButton: UIButton {

    private let buttonSize: CGFloat
    public init(image: UIImage = Icons.topNavigationUp24, size: CGFloat = 42) {
        self.buttonSize = size
        super.init(frame: .zero)
        setImage(image, for: .normal)
        configureUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func configureUI() {
        // Visuals
        backgroundColor = Colors.white
        imageView?.contentMode = .center

        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.withAlphaComponent(0.25).cgColor
        layer.shadowOpacity = 1
        layer.shadowRadius = 4
        layer.shadowOffset = CGSize(width: 0, height: 4)
    }

    public override var intrinsicContentSize: CGSize {
        CGSize(width: buttonSize, height: buttonSize)
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius).cgPath
    }

    public override var isHighlighted: Bool {
        didSet {
            let transform: CGAffineTransform = isHighlighted ? CGAffineTransform(scaleX: 0.96, y: 0.96) : .identity
            UIView.animate(withDuration: 0.12, delay: 0, options: [.allowUserInteraction, .curveEaseOut], animations: {
                self.transform = transform
                self.alpha = self.isHighlighted ? 0.9 : 1.0
            }, completion: nil)
        }
    }
}
