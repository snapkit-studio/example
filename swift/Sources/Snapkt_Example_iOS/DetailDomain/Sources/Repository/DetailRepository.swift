//
//  DetailRepository.swift
//  Domain
//
//  Created by 김재한 on 9/30/25.
//

import Foundation
import RxSwift

public protocol DetailRepository {
    func fetchDetail() -> Single<Detail>
}
