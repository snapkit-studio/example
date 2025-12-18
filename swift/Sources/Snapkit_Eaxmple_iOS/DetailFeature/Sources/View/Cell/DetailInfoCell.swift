//
//  DetailInfoCell.swift
//  DetailFeature
//
//  Created by 김재한 on 10/3/25.
//

import UIKit
import Design
import DetailDomain

public final class DetailInfoCell: UICollectionViewCell {
    
    private let titleLabel: TypographyLabel = {
        let label = TypographyLabel(typography: .bold)
        label.lineBreakMode = .byClipping
        label.numberOfLines = 2
        return label
    }()
    
    private let periodLabel: TypographyLabel = {
        let label = TypographyLabel()
        return label
    }()
    
    private let descriptionLabel: TypographyLabel = {
        let label = TypographyLabel()
        label.numberOfLines = 0
        return label
    }()
    
    private let divider: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.dividerColor
        return view
    }()
    
    private let infoTitieLabel: TypographyLabel = {
        let label = TypographyLabel(typography: .bold)
        label.text = "정보"
        return label
    }()
    
    private let pinImageView: UIImageView = {
        let view = UIImageView(image: Icons.pin)
        return view
    }()
    
    private let addressLabel: TypographyLabel = {
        let label = TypographyLabel()
        label.numberOfLines = 0
        return label
    }()
    
    private let clockImageView: UIImageView = {
        let view = UIImageView(image: Icons.clock)
        return view
    }()
    
    private let openingInfoLabel: TypographyLabel = {
        let label = TypographyLabel()
        label.numberOfLines = 0
        return label
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(model: Detail) {
        titleLabel.text = model.title
        periodLabel.text = model.period
        descriptionLabel.text = model.description
        addressLabel.text = model.location
        openingInfoLabel.text = model.locationOpeningHourInfo
    }
    
    private func setUpView() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(periodLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(divider)
        contentView.addSubview(infoTitieLabel)
        contentView.addSubview(pinImageView)
        contentView.addSubview(addressLabel)
        contentView.addSubview(clockImageView)
        contentView.addSubview(openingInfoLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.horizontalEdges.equalToSuperview()
        }
        
        periodLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(periodLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview()
        }
        
        divider.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(20)
            make.height.equalTo(1)
            make.horizontalEdges.equalToSuperview()
        }
        
        infoTitieLabel.snp.makeConstraints { make in
            make.top.equalTo(divider.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview()
        }
        
        pinImageView.snp.makeConstraints { make in
            make.top.equalTo(infoTitieLabel.snp.bottom).offset(12)
            make.size.equalTo(24)
            make.leading.equalToSuperview()
        }
        
        addressLabel.snp.makeConstraints { make in
            make.top.equalTo(pinImageView.snp.top)
            make.leading.equalTo(pinImageView.snp.trailing).offset(4)
        }
        
        clockImageView.snp.makeConstraints { make in
            make.size.equalTo(24)
            make.top.equalTo(addressLabel.snp.bottom).offset(12)
            make.leading.equalToSuperview()
        }
        
        openingInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(clockImageView.snp.top)
            make.leading.equalTo(clockImageView.snp.trailing).offset(12)
        }
    }
}

