//
//  PlaceHeaderView.swift
//  Feature
//
//  Created by 김재한 on 10/2/25.
//

import Foundation
import UIKit
import RxSwift
import RxSupport
import ReactorKit
import Design

public final class PlaceHeaderView: UICollectionReusableView, @MainActor View {
    
    public typealias Reactor = HomeReactor
    public var disposeBag = DisposeBag()
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        return view
    }()
    
    private let containerView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 4
        view.distribution = .equalSpacing
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
        removeButtons()
    }
    
    public func bind(reactor: HomeReactor) {
        reactor.state
            .map(\.placeButtonsModels)
            .distinctUntilChanged()
            .subscribe(on: MainScheduler.asyncInstance)
            .subscribe { [weak self] in
                self?.removeButtons()
                self?.addButton(with: $0)
            }.disposed(by: disposeBag)
    }
    
    private func setUpView() {
        backgroundColor = Colors.white
        addSubview(scrollView)
        scrollView.addSubview(containerView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        containerView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.verticalEdges.equalToSuperview().inset(16)
        }
    }
    
    private func addButton(with model: [TagPresentationModel]) {
        model.forEach { item in
            let button = TagButton()
            button.configure(text: item.name, isSelected: item.isSelected)
            containerView.addArrangedSubview(button)

            button.rx.tapGesture()
                .filter { $0.state == .recognized }
                .subscribe(onNext: { [weak self, item] _ in
                    self?.reactor?.action.onNext(HomeReactor.HomeAction.tapPlaceTag(item.id))
                })
                .disposed(by: disposeBag)
        }
    }
    
    private func removeButtons() {
        containerView.subviews.forEach {
            $0.removeFromSuperview()
        }
    }
}

