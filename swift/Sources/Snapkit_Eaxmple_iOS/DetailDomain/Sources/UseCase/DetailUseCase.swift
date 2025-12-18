//
//  DetailUseCase.swift
//  DetailDomain
//
//  Created by 김재한 on 10/3/25.
//

import Foundation
import RxSwift
import CoreDomain

public protocol DetailUseCase {
    func fetchDetail() -> Single<Detail>
}

public final class DetailUseCaseImpl: DetailUseCase {
    private let repository: DetailRepository
    
    public init(repository: DetailRepository) {
        self.repository = repository
    }
    
    public func fetchDetail() -> Single<Detail> {
        repository.fetchDetail()
    }
}
