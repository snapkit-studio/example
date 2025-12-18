//
//  DetailViewController.swift
//  DetailFeature
//
//  Created by 김재한 on 10/3/25.
//

import Foundation
import DetailDomain
import ReactorKit
import RxSwift
import UIKit
import Design
import RxSupport
import CoreDomain

public final class DetailViewController: UIViewController, @MainActor View {

    public typealias Reactor = DetailReactor
    public var disposeBag = DisposeBag()
    
    private typealias DataSource = UICollectionViewDiffableDataSource<DetailSection, DetailItem>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<DetailSection, DetailItem>
    
    private var dataSource: DataSource?
    private var currentImagePageIndex: Int = -1
    
    private let navigationView = NavigationView()
    private let refreshControl = UIRefreshControl()
    
    private let displayView = DisplayInfoView()
    
    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(
            frame: .zero,
            collectionViewLayout: createCompositionLayout()
        )
        view.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        return view
    }()
    
    private let paginationView: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.black.withAlphaComponent(0.7)
        view.layer.cornerRadius = 8
        return view
    }()
    
    private let paginationLabel: TypographyLabel = {
        let label = TypographyLabel(color: Colors.white)
        return label
    }()
    
    public init(reactor: Reactor) {
        defer { self.reactor = reactor }
        super.init(nibName: nil, bundle: nil)
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        setDataSource()
        reactor?.action.onNext(Reactor.Action.initialize)
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ImageDownloader.shared.clearData()
    }
    
    public func bind(reactor: Reactor) {
        navigationView.rx
            .tapGesture()
            .filter { $0.state == .recognized }
            .subscribe { [weak self] _ in
                self?.reactor?.action.onNext(Reactor.DetailAction.leave)
            }.disposed(by: disposeBag)
        
        reactor.state
            .map(\.sections)
            .subscribe(on: MainScheduler.asyncInstance)
            .subscribe { [weak self] sections in
                if self?.refreshControl.isRefreshing == true {
                    self?.refreshControl.endRefreshing()
                }
                self?.apply(sections: sections)
            }.disposed(by: disposeBag)
        
        reactor.state
            .map(\.pagination)
            .subscribe(on: MainScheduler.asyncInstance)
            .subscribe { [weak self] in
                self?.paginationLabel.text = $0
            }.disposed(by: disposeBag)
        
        ImageDownloader.shared.displayInfo
            .subscribe(on: MainScheduler.asyncInstance)
            .subscribe { [weak self] in
                self?.displayView.configure(memory: $0.memory, time: $0.time, count: $0.count)
            }.disposed(by: disposeBag)
    }
    
    private func setUpView() {
        view.backgroundColor = Colors.white
        view.addSubview(navigationView)
        collectionView.addSubview(paginationView)
        paginationView.layer.zPosition = 1
        view.addSubview(collectionView)
        paginationView.addSubview(paginationLabel)
        navigationView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.horizontalEdges.equalToSuperview()
        }
        view.addSubview(displayView)
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(navigationView.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        paginationView.snp.makeConstraints { make in
            make.top.equalTo(collectionView.contentLayoutGuide.snp.top).offset(339)
            make.trailing.equalTo(collectionView.frameLayoutGuide.snp.trailing).inset(16)
        }
        
        paginationLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(2)
            make.horizontalEdges.equalToSuperview().inset(8)
        }
        
        displayView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.centerX.equalToSuperview()
        }
    }
    
    @objc private func handleRefresh() {
        reactor?.action.onNext(Reactor.Action.refresh)
    }
    
    private func apply(sections: [SectionPresenter]) {
        var snapshot = Snapshot()
        snapshot.appendSections(sections.map { $0.section() })
        for section in sections {
            snapshot.appendItems(section.items(), toSection: section.section())
        }
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    private func setDataSource() {
        let imageCell = UICollectionView.CellRegistration<DetailImageCell, DetailPresentation>{ cell, _, item in
            cell.configure(model: item)
        }
        
        let infoCell = UICollectionView.CellRegistration<DetailInfoCell, Detail>{ cell, _, item in
            cell.configure(model: item)
        }
        
        dataSource = DataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case .image(let image):
                collectionView.dequeueConfiguredReusableCell(using: imageCell, for: indexPath, item: image)
            case .info(let detail):
                collectionView.dequeueConfiguredReusableCell(using: infoCell, for: indexPath, item: detail)
            }
        })
    }
    
    private func createCompositionLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { [weak self] sectionIndex, environment in
            let section = self?.dataSource?.sectionIdentifier(for: sectionIndex) as? DetailSection
            switch section {
            case .images:
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .estimated(375)
                )
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                let sectionLayout = NSCollectionLayoutSection(group: group)
                sectionLayout.orthogonalScrollingBehavior = .groupPaging
                sectionLayout.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0)
                
                sectionLayout.visibleItemsInvalidationHandler = { [weak self] _, contentOffset, environment in
                    let width = environment.container.effectiveContentSize.width
                    guard width > 0 else { return }
                    let index = Int(round(contentOffset.x / width))
                    guard index != self?.currentImagePageIndex else { return }
                    self?.currentImagePageIndex = index
                    self?.reactor?.action.onNext(Reactor.DetailAction.pageScroll(index))
                }
                
                return sectionLayout
                
            case .info:
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .estimated(365)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0)
                )
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                let sectionLayout = NSCollectionLayoutSection(group: group)
                sectionLayout.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 40, trailing: 16)
                return sectionLayout
            case .none:
                return nil
            }
        }
    }
}

