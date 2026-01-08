//
//  DetailReactor.swift
//  DetailFeature
//
//  Created by 김재한 on 10/3/25.
//

import Foundation
import CoreDomain
import DetailDomain
import RxSwift
import ReactorKit

public class DetailReactor: Reactor {
    public typealias Action = DetailAction
    public typealias State = DetailState
    
    public enum DetailAction {
        case initialize
        case refresh
        case pageScroll(Int)
        case leave
    }
    
    public struct DetailState {
        var sections: [SectionPresenter] = []
        var pagination: String = ""
    }
    
    public enum Mutation {
        case setSections([SectionPresenter])
        case setPagination(String)
    }
    
    public let route = PublishSubject<DetailRoute>()
    public let initialState = DetailState()
    private let useCase: DetailUseCase
    private let mapper: PresentationMappale
    
    public init(useCase: DetailUseCase, mapper: PresentationMappale) {
        self.useCase = useCase
        self.mapper = mapper
    }
    
    public func mutate(action: DetailAction) -> Observable<Mutation> {
        switch action {
        case .initialize, .refresh:
            return useCase.fetchDetail()
                .asObservable()
                .map { detail -> ([SectionPresenter], Int) in
                    let sections: [SectionPresenter] = [
                        SectionPresenter(section: .images, items: detail.imageURLs.map { .image(self.mapper.transform(from: $0)) }),
                        SectionPresenter(section: .info, items: [.info(detail)])
                    ]
                    let count = detail.imageURLs.count
                    return (sections, count)
                }
                .flatMap { sections, count -> Observable<Mutation> in
                    let pagination = "1/\(count)"
                    return Observable.from([
                        Mutation.setSections(sections),
                        Mutation.setPagination(pagination)
                    ])
                }
        case .pageScroll(let index):
            let count = currentState.pagination.split(separator: "/").last ?? ""
            let page = String(index + 1)
            return .just(Mutation.setPagination("\(page)/\(count)"))
        case .leave:
            route.onNext(.leave)
            return .empty()
        }
    }
    
    public func reduce(state: DetailState, mutation: Mutation) -> DetailState {
        var newState = state
        switch mutation {
        case .setSections(let sections):
            newState.sections = sections
        case .setPagination(let page):
            newState.pagination = page
        }
        return newState
    }
}

