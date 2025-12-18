//
//  HomeUseCase.swift
//  Domain
//
//  Created by 김재한 on 9/30/25.
//

import Foundation
import RxSwift
import CoreDomain

public protocol HomeUseCase {
    func fetchBanner() -> Single<Banner>
    func fetchCategories() -> Single<[HomeCategory]>
    func fetchCurations() -> Single<[Curation]>
    func fetchPlaces(_ id: Int) -> Single<[Place]>
    func fetchTags() -> Single<[Tag]>
}

public class HomeUseCaseImpl: HomeUseCase {
    
    private let homeRepository: HomeRepository
    
    public init(homeRepository: HomeRepository) {
        self.homeRepository = homeRepository
        
    }
    
    public func fetchBanner() -> Single<Banner> {
        homeRepository.fetchBanner()
    }
    
    public func fetchCategories() -> Single<[HomeCategory]> {
        homeRepository.fetchCategories()
    }
    
    public func fetchCurations() -> Single<[Curation]> {
        homeRepository.fetchCurations()
    }
    
    public func fetchPlaces(_ id: Int) -> Single<[Place]> {
        homeRepository.fetchPlaces(String(id + 1))
    }
    
    public func fetchTags() -> Single<[Tag]> {
        homeRepository.fetchTags()
    }
}

