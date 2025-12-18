import Foundation
import RxSwift

public final class MockNetworkServiceProvider: NetworkServiceProvidable {
    
    private let decoder: JSONDecoder

    public init(decoder: JSONDecoder = JSONDecoder()) {
        self.decoder = decoder
    }
    
    public func request<T>(_ config: APIConfig, as type: T.Type) -> RxSwift.Single<T> where T : Decodable, T : Sendable {
        return Single<T>.create { [decoder] observer in
            do {
                let fileName = config.snapkitPath

                let mockDirURL = Bundle.main.url(forResource: fileName, withExtension: "json")

                guard let mockDirURL else {
                    throw NSError(domain: "MockNetworkServiceProvider", code: 2, userInfo: [NSLocalizedDescriptionKey: "MockData directory not found in bundle"]) 
                }

                let data = try Data(contentsOf: mockDirURL)
                let decoded = try decoder.decode(T.self, from: data)
                observer(.success(decoded))
            } catch {
                observer(.failure(error))
            }
            return Disposables.create()
        }
    }
}

