//
//  HomeRepository.swift
//  Domain
//
//  Created by 김재한 on 9/30/25.
//

import Foundation
import RxSwift

public protocol HomeRepository {
    func fetchBanner() -> Single<Banner>
    func fetchCategories() -> Single<[HomeCategory]>
    func fetchCurations() -> Single<[Curation]>
    func fetchPlaces(_ id: String) -> Single<[Place]>
    func fetchTags() -> Single<[Tag]>
}
