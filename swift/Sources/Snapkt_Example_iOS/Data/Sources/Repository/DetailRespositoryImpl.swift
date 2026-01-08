//
//  DetailRespositoryImpl.swift
//  Data
//
//  Created by 김재한 on 9/30/25.
//

import Foundation
import DetailDomain
import RxSwift

public class DetailRepositoryImpl: DetailRepository {
    
    private let networkService: NetworkServiceProvidable
    
    public init(networkService: NetworkServiceProvidable) {
        self.networkService = networkService
    }
    
    public func fetchDetail() -> Single<Detail> {
        networkService
            .request(.detail, as: DetailResponseModel.self)
            .map { $0.toDomain()}
    }
}
