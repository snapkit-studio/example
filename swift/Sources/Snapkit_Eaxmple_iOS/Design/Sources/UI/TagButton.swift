//
//  TagButton.swift
//  Design
//
//  Created by 김재한 on 10/1/25.
//

import Foundation
import UIKit
import SnapKit

public class TagButton: UIControl {
    private let titleLabel: TypographyLabel = {
        let label = TypographyLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    public var title: String? {
        get { titleLabel.text }
        set { titleLabel.text = newValue }
    }

    public override var isSelected: Bool {
        didSet { updateAppearance() }
    }

    public override var isHighlighted: Bool {
        didSet { updateAppearance() }
    }

    public override var isEnabled: Bool {
        didSet { updateAppearance() }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(text: String, isSelected: Bool) {
        titleLabel.text = text
        self.isSelected = isSelected
    }

    private func setup() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(8)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        layer.cornerRadius = 18
        updateAppearance()
    }

    private func updateAppearance() {
        if isSelected {
            backgroundColor = Colors.TagButton.selectBackgroundColor
            titleLabel.textColor = Colors.TagButton.selecteTextColor
            layer.borderWidth = 1
            layer.borderColor = Colors.TagButton.layerColor.cgColor
        } else {
            backgroundColor = Colors.TagButton.backgroundColor
            titleLabel.textColor = Colors.TagButton.textColor
            layer.borderWidth = 0
            layer.borderColor = UIColor.clear.cgColor
        }
    }
}
