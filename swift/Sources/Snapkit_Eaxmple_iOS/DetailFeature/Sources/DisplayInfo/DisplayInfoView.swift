//
//  DisplayInfoView.swift
//  HomeFeature
//
//  Created by 김재한 on 12/15/25.
//

import Foundation
import UIKit
import Design

public class DisplayInfoView: UIView {
    private let totalMemmorayLabel: TypographyLabel = {
        let label = TypographyLabel(color: Colors.white)
        return label
    }()
    
    private let lcpLabel: TypographyLabel = {
        let label = TypographyLabel(color: Colors.white)
        return label
    }()
    
    private let maxCountLabel: TypographyLabel = {
        let label = TypographyLabel(color: Colors.white)
        return label
    }()
    
    private let containerView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
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
    
    public func configure(memory: Int, time: Double, count: Int) {
        let seconds = time / 1000.0
        totalMemmorayLabel.text = "Downloaded: \(formatBytes(memory)) bytes"
        lcpLabel.text = "LCP: \(String(format: "%.2f sec", seconds)) sec"
        maxCountLabel.text = "Images: \(count)"
    }
    
    private func formatBytes(_ bytes: Int) -> String {
        let units = ["bytes", "KB", "MB", "GB", "TB"]
        var value = Double(bytes)
        var unitIndex = 0
        while value >= 1024.0 && unitIndex < units.count - 1 {
            value /= 1024.0
            unitIndex += 1
        }
        if unitIndex == 0 { // bytes, show as integer
            return "\(Int(value)) bytes"
        } else {
            return String(format: "%.2f %@", value, units[unitIndex])
        }
    }
    
    private func setUpView() {
        addSubview(containerView)
        containerView.addArrangedSubview(totalMemmorayLabel)
        containerView.addArrangedSubview(lcpLabel)
        containerView.addArrangedSubview(maxCountLabel)
        
        containerView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(22)
            make.horizontalEdges.equalToSuperview().inset(45)
        }
        
        layer.cornerRadius = 16
        backgroundColor = .black.withAlphaComponent(0.6)
    }
}
