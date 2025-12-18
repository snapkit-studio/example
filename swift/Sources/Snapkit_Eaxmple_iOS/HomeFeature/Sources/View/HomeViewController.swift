//
//  HomeViewController.swift
//  Feature
//
//  Created by 김재한 on 9/30/25.
//

import Foundation
import UIKit
import Design
import SnapKit
import RxSwift
import RxSupport
import ReactorKit
import CoreDomain
import HomeDomain

public class HomeViewController: UIViewController, @MainActor View {
    
    public typealias Reactor = HomeReactor
    public var disposeBag = DisposeBag()
    
    private typealias DataSource = UICollectionViewDiffableDataSource<HomeSection, HomeItem>
    private var dataSource: DataSource?
    private let refreshControl = UIRefreshControl()
    
    private let displayView = DisplayInfoView()
    
    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        view.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        return view
    }()
    
    private let floatingButton = FloatingButton(image: Icons.topNavigationUp24)
    
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
        reactor?.action.onNext(.intialize)
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        extendedLayoutIncludesOpaqueBars = true
        ImageDownloader.shared.clearData()
    }
    
    public func bind(reactor: Reactor) {
        reactor.state
            .map(\.sections)
            .distinctUntilChanged()
            .subscribe(on: MainScheduler.asyncInstance)
            .subscribe { [weak self] sections in
                if self?.refreshControl.isRefreshing == true {
                    self?.refreshControl.endRefreshing()
                }
                self?.apply(sections: sections)
            }.disposed(by: disposeBag)
        
        reactor.state
            .map(\.updatedSections)
            .distinctUntilChanged()
            .subscribe(on: MainScheduler.asyncInstance)
            .subscribe { [weak self] sections in
                self?.apply(updatedSections: sections)
            }.disposed(by: disposeBag)
    }
    
    private func setUpView() {
        view.addSubview(collectionView)
        view.addSubview(floatingButton)
        view.addSubview(displayView)

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        floatingButton.snp.makeConstraints { make in
            make.size.equalTo(42)
            make.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(16)
        }
        
        floatingButton.rx
            .tapGesture()
            .filter { $0.state == .recognized }
            .subscribe(onNext: { [weak self] _ in
                self?.handleFloatingButtonTap()
            })
            .disposed(by: disposeBag)
        
        displayView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.centerX.equalToSuperview()
        }
        
        ImageDownloader.shared.displayInfo
            .subscribe(on: MainScheduler.asyncInstance)
            .subscribe { [weak self] in
                self?.displayView.configure(memory: $0.memory, time: $0.time, count: $0.count)
            }.disposed(by: disposeBag)
    }
    
    @objc private func handleRefresh() {
        reactor?.action.onNext(Reactor.Action.refresh)
    }
    
    @objc private func handleFloatingButtonTap() {
        let topOffset = CGPoint(x: 0, y: -collectionView.adjustedContentInset.top)
        collectionView.setContentOffset(topOffset, animated: true)
    }
    
    private func apply(sections: [SectionPresenter]) {
        var snapshot = NSDiffableDataSourceSnapshot<HomeSection, HomeItem>()
        snapshot.appendSections(sections.map { $0.section() })
        for section in sections {
            snapshot.appendItems(section.items(), toSection: section.section())
        }
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    private func apply(updatedSections: [SectionPresenter]) {
        guard var snapshot = dataSource?.snapshot() else { return }

        for presenter in updatedSections {
            let sectionID = presenter.section()
            let newItems = presenter.items()

            // If the section doesn't exist yet, append it and its items.
            if snapshot.indexOfSection(sectionID) == nil {
                snapshot.appendSections([sectionID])
                snapshot.appendItems(newItems, toSection: sectionID)
                continue
            }

            let oldItems = snapshot.itemIdentifiers(inSection: sectionID)

            if oldItems == newItems {
                // Same identifiers and order; just ask cells to reconfigure without animation.
                if #available(iOS 15.0, *) {
                    snapshot.reconfigureItems(newItems)
                } else {
                    snapshot.reloadItems(newItems)
                }
            } else {
                // Replace the section's items to reflect the new state (no animation).
                snapshot.deleteItems(oldItems)
                snapshot.appendItems(newItems, toSection: sectionID)
            }
        }

        dataSource?.apply(snapshot, animatingDifferences: false)
    }
    
    private func createLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { [weak self] sectionIndex, environment in
            let section = self?.dataSource?.sectionIdentifier(for: sectionIndex) as? HomeSection
            switch section {
            case .banner:
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(56)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)

                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(56)
                )
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

                let sectionLayout = NSCollectionLayoutSection(group: group)
                return sectionLayout
            case .categories:
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(92)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)

                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(92)
                )
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

                let sectionLayout = NSCollectionLayoutSection(group: group)
                return sectionLayout
            case .categoriesDivider:
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(8)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)

                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(8)
                )
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

                let sectionLayout = NSCollectionLayoutSection(group: group)
                sectionLayout.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 24, trailing: 0)
                return sectionLayout
                
            case .curationsHeader:
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .estimated(32)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)

                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .estimated(32)
                )
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

                let sectionLayout = NSCollectionLayoutSection(group: group)
                sectionLayout.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
                return sectionLayout
            case .curations:
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)

                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .absolute(195),
                    heightDimension: .estimated(318)
                )
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

                let sectionLayout = NSCollectionLayoutSection(group: group)
                sectionLayout.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
                sectionLayout.interGroupSpacing = 12
                sectionLayout.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 16, bottom: 0, trailing: 16)

                return sectionLayout
            case .curationsDivider:
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(64)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)

                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(64)
                )
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

                let sectionLayout = NSCollectionLayoutSection(group: group)
                return sectionLayout
            case .placeDivider:
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(8)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(8)
                )
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                let sectionLayout = NSCollectionLayoutSection(group: group)
                sectionLayout.contentInsets = NSDirectionalEdgeInsets(top: 48, leading: 0, bottom: 0, trailing: 0)
                return sectionLayout
            case .places:
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .estimated(148)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .estimated(148)
                )
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                let header = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: .init(widthDimension: .fractionalWidth(1.0),
                                      heightDimension: .estimated(68)),
                    elementKind: UICollectionView.elementKindSectionHeader,
                    alignment: .top
                )
                header.pinToVisibleBounds = true
                let sectionLayout = NSCollectionLayoutSection(group: group)
                sectionLayout.boundarySupplementaryItems = [header]
                return sectionLayout
            case .none:
                return nil
            }
        }
    }
    
    private func setDataSource() {
        let bannerCell = UICollectionView.CellRegistration<HomeBannerCell, Banner> { (cell, _, item) in
            cell.configure(banner: item)
        }
        
        let homeCategoryCell = UICollectionView.CellRegistration<HomeCategoryCell, [HomeCategoryPresentation]> { (cell, _, item) in
            cell.configure(model: item)
        }
        
        let dividerCell = UICollectionView.CellRegistration<DividerCell, Void> { _, _, _  in }
        
        let curationHeaderCell = UICollectionView.CellRegistration<CurationHeaderCell, String> { cell, _, item in
            cell.configure(title: item)
        }
        
        let curationCell = UICollectionView.CellRegistration<CurationCell, CurationInfoPresentation> { cell, _, item in
            cell.configure(model: item)
            cell.rx
                .tapGesture()
                .filter { $0.state == .recognized }
                .subscribe(onNext: { [weak self] _ in
                    self?.reactor?.route.on(.next(.detail))
                })
                .disposed(by: cell.disposeBag)
        }
        
        let curationDivider = UICollectionView.CellRegistration<CurationDividerCell, Void> { _, _, _ in }
        
        let placeHeaderView = UICollectionView.SupplementaryRegistration<PlaceHeaderView>(elementKind: UICollectionView.elementKindSectionHeader) { [weak self] headerView, elementKind, indexPath in
            headerView.reactor = self?.reactor
        }
        
        let placeCell = UICollectionView.CellRegistration<PlaceCell, PlacePresentation> { cell, _, item in
            cell.configure(model: item)
            cell.rx
                .tapGesture()
                .filter { $0.state == .recognized }
                .subscribe(onNext: { [weak self] _ in
                    self?.reactor?.route.on(.next(.detail))
                })
                .disposed(by: cell.disposeBag)
        }
        
        dataSource = DataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            return switch itemIdentifier {
            case .banner(let banner):
                collectionView.dequeueConfiguredReusableCell(using: bannerCell, for: indexPath, item: banner)
            case .category(let categories):
                collectionView.dequeueConfiguredReusableCell(using: homeCategoryCell, for: indexPath, item: categories)
            case .divider, .placeDivider:
                collectionView.dequeueConfiguredReusableCell(using: dividerCell, for: indexPath, item: ())
            case .curationHeader(let item):
                collectionView.dequeueConfiguredReusableCell(using: curationHeaderCell, for: indexPath, item: item)
            case .curation(let item):
                collectionView.dequeueConfiguredReusableCell(using: curationCell, for: indexPath, item: item)
            case .curationDivider:
                collectionView.dequeueConfiguredReusableCell(using: curationDivider, for: indexPath, item: ())
            case .place(let place):
                collectionView.dequeueConfiguredReusableCell(using: placeCell, for: indexPath, item: place)
            }
        })
        
        dataSource?.supplementaryViewProvider = { collectionView, kind, indexPath in
            if kind == UICollectionView.elementKindSectionHeader {
                return collectionView.dequeueConfiguredReusableSupplementary(using: placeHeaderView, for: indexPath)
            }
            return nil
        }
    }
}

