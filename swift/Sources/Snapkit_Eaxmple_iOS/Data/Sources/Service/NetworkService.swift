//
//  NetworkService.swift
//  Data
//
//  Created by 김재한 on 9/30/25.
//

import Foundation
import Alamofire
import RxSwift

public protocol NetworkServiceProvidable: Sendable {
    func request<T: Decodable & Sendable>(_ config: APIConfig, as type: T.Type) -> Single<T>
}

public final class NetworkServiceProvider: NetworkServiceProvidable {
    
    public init() {
        
    }
    
    public func request<T: Decodable & Sendable>(_ config: APIConfig, as type: T.Type) -> Single<T> {
        return Single.create { single in
            nonisolated(unsafe) let emit = single
            let req = AF.request(config.path, method: HTTPMethod(rawValue: config.method))
                .cURLDescription { print($0) }
                .validate()
                .responseDecodable(of: T.self) { response in
                    switch response.result {
                    case .success(let value):
                        emit(.success(value))
                    case .failure(let error):
                        emit(.failure(error))
                    }
                }
            
            return Disposables.create { req.cancel() }
        }
    }
}
