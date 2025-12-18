//
//  HomeReactorKit.swift
//  Feature
//
//  Created by 김재한 on 9/30/25.
//

import Foundation
import CoreDomain
import HomeDomain
import ReactorKit
import RxSwift

public class HomeReactor: Reactor {
    public typealias Action = HomeAction
    public typealias State = HomeState
    
    public enum HomeAction {
        case intialize
        case refresh
        case tapPlaceTag(Int)
        case tapContent
    }
    
    public struct HomeState {
        var sections: [SectionPresenter] = []
        var updatedSections: [SectionPresenter] = []
        var placeButtonsModels: [TagPresentationModel] = []
    }
    
    public enum Mutation {
        case setSection([SectionPresenter])
        case updateSections([SectionPresenter])
        case setPlaceButton([TagPresentationModel])
    }
    
    public let initialState = HomeState()
    private let useCase: HomeUseCase
    private let mapper: PresentationMappale
    public let route = PublishSubject<HomeRoute>()
    
    public init(useCase: HomeUseCase, mapper: PresentationMappale) {
        self.useCase = useCase
        self.mapper = mapper
    }
    
    public func mutate(action: HomeAction) -> Observable<Mutation> {
        switch action {
        case .intialize, .refresh:
            let zipped = Single.zip(
                useCase.fetchBanner(),
                useCase.fetchCategories(),
                useCase.fetchCurations(),
                useCase.fetchPlaces(PlaceType.whole.rawValue)
            )
            .asObservable()
            .map { banner, categories, curations, places in
                let bannerSection = SectionPresenter(homeSection: .banner, homeItems: [.banner(banner)])
                let categoriesSection = SectionPresenter(homeSection: .categories, homeItems: [.category(self.mapper.transform(from: categories))])
                let categoriesDivider = SectionPresenter(homeSection: .categoriesDivider, homeItems: [.divider])
                var curationsSections = curations.map { curation in
                    [
                        SectionPresenter(homeSection: .curationsHeader(), homeItems: [.curationHeader(curation.title)]),
                        SectionPresenter(homeSection: .curations(), homeItems: curation.info.map { .curation(self.mapper.transform(from: $0)) }),
                        SectionPresenter(homeSection: .curationsDivider(), homeItems: [.curationDivider])
                    ]
                }.flatMap { $0 }.dropLast()
                curationsSections.append(SectionPresenter(homeSection: .placeDivider, homeItems: [.placeDivider]))
                let placesSection = SectionPresenter(homeSection: .places, homeItems: places.map { place in .place(self.mapper.transform(from: place)) })
                curationsSections.append(placesSection)
                return Mutation.setSection(
                    [bannerSection, categoriesSection, categoriesDivider] + curationsSections
                )
            }
            .catch { error in
                return .just(Mutation.setSection([]))
            }
            let result = useCase.fetchTags()
                .asObservable()
                .map {
                    $0.enumerated().map { value in
                        TagPresentationModel(id: value.offset, tag: value.element)
                    }
                }.map {
                    Mutation.setPlaceButton($0)
                }
            return .concat(zipped, result)
        case .tapPlaceTag(let id):
            let placesResult = useCase.fetchPlaces(id)
                .asObservable()
                .map { places in
                    SectionPresenter(homeSection: .places, homeItems: places.map { place in .place(self.mapper.transform(from: place)) })
                }.map {
                    Mutation.updateSections([$0])
                }
            let updatedTagModel = currentState.placeButtonsModels.map {
                TagPresentationModel(id: $0.id, tag: Tag(name: $0.name), selctedID: id)
            }
            return .concat(
                placesResult,
                .just(Mutation.setPlaceButton(updatedTagModel))
            )
        case .tapContent:
            route.onNext(.detail)
            return .empty()
        }
    }
    
    public func reduce(state: HomeState, mutation: Mutation) -> HomeState {
        var newState = state
        switch mutation {
        case .setSection(let sections):
            newState.sections = sections
        case .updateSections(let sectoins):
            newState.updatedSections = sectoins
        case .setPlaceButton(let placeButtonModels):
            newState.placeButtonsModels = placeButtonModels
        }
        return newState
    }
}

