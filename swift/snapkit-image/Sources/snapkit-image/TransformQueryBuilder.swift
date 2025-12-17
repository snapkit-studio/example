//
//  TransformQueryBuilder.swift
//  snapkit-image
//
//  Created by 김재한 on 12/17/25.
//

import Foundation

/// Builds transform query strings and URLs from TransformOptions values
public struct TransformQueryBuilder {
    
    private let url: URL?
    
    public init(url: URL?) {
        self.url = url
    }

    /// Builds only the transform value (without the leading "?transform=") for use in query items.
    private func buildTransformValue(options: TransformOptions) -> String {
        let transformString = options.buildTransformString()
        let prefix = "?transform="
        return transformString.hasPrefix(prefix) ? String(transformString.dropFirst(prefix.count)) : transformString
    }

    /// Builds a URL by appending the transform query (name: "transform") to the given base URL.
    public func buildTransformURL(options: TransformOptions) -> URL? {
        guard let url else { return nil }
        let value = buildTransformValue(options: options)
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        var items = components?.queryItems ?? []
        items.removeAll { $0.name == "transform" }
        items.append(URLQueryItem(name: "transform", value: value))
        components?.queryItems = items
        return components?.url
    }
}
