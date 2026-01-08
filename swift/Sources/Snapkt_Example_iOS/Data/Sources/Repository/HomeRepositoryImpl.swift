//
//  HomeRepositoryImpl.swift
//  Data
//
//  Created by 김재한 on 9/30/25.
//

import Foundation
import HomeDomain
import RxSwift
import CoreDomain

public class HomeRepositoryImpl: HomeRepository {
    
    private let networkService: NetworkServiceProvidable
    
    public init(networkService: NetworkServiceProvidable) {
        self.networkService = networkService
    }
    
    public func fetchBanner() -> Single<HomeDomain.Banner> {
        networkService
            .request(.banner, as: BannerResponseModel.self)
            .map { $0.toDomain() }
    }
    
    public func fetchCategories() -> Single<[HomeDomain.HomeCategory]> {
        networkService
            .request(.categories, as: CategoryResponseModel.self)
            .map { $0.toDomain() }
    }
    
    public func fetchCurations() -> Single<[HomeDomain.Curation]> {
        networkService
            .request(.curations, as: CurationsResponseModel.self)
            .map { $0.toDomain() }
    }
    
    public func fetchPlaces(_ id: String) -> Single<[HomeDomain.Place]> {
        networkService
            .request(.place(id), as: PlacesResponseModel.self)
            .map { $0.toDomain() }
    }
    
    public func fetchTags() -> Single<[HomeDomain.Tag]> {
        networkService
            .request(.tags, as: TagsResponseModel.self)
            .map { $0.toDomain() }
    }
}
