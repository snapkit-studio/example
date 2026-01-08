//
//  ImageDownloader.swift
//  Data
//
//  Created by 김재한 on 12/15/25.
//

import Foundation
import os
import RxSwift
import UIKit

public struct DisplayInfo {
    public let memory: Int
    public let time: Double
    public let count: Int
    
    public init(memory: Int, time: Double, count: Int) {
        self.memory = memory
        self.time = time
        self.count = count
    }
}

@MainActor
public class ImageDownloader {
    
    private static let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "ImageDownloader", category: "ImageDownload")
    
    private var totalMemory: Int = 0
    private var maxElapsedMS: Double = 0
    private var totalCount: Int = 0
    public static let shared = ImageDownloader()
    
    public var displayInfo = PublishSubject<DisplayInfo>()
    
    private init() {
        
    }
    
    public func downloadImage(from url: URL?) async throws -> UIImage {
        guard let url else {
            let error = NSError(domain: "ImageDownloader", code: 0, userInfo: [NSLocalizedDescriptionKey: "URL is nil"])
            Self.logger.error("Image download failed for nil URL")
            throw error
        }

        let startTime = Date()
        var request = URLRequest(url: url)
        request.cachePolicy = .reloadIgnoringLocalCacheData

        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await URLSession.shared.data(for: request)
        } catch {
            let elapsedMS = Date().timeIntervalSince(startTime) * 1000
            Self.logger.error("Image download failed for \(url.absoluteString, privacy: .public) after \(elapsedMS, format: .fixed(precision: 2)) ms: \(error.localizedDescription, privacy: .public)")
            throw error
        }

        let elapsedMS = Date().timeIntervalSince(startTime) * 1000

        guard let http = response as? HTTPURLResponse else {
            Self.logger.error("Image download failed for \(url.absoluteString, privacy: .public) after \(elapsedMS, format: .fixed(precision: 2)) ms: missing HTTPURLResponse")
            throw URLError(.badServerResponse)
        }

        guard (200..<300).contains(http.statusCode) else {
            Self.logger.error("Image download failed for \(url.absoluteString, privacy: .public) after \(elapsedMS, format: .fixed(precision: 2)) ms: status \(http.statusCode)")
            throw URLError(.badServerResponse)
        }

        guard !data.isEmpty else {
            Self.logger.error("Image download failed for \(url.absoluteString, privacy: .public) after \(elapsedMS, format: .fixed(precision: 2)) ms: zero-byte resource")
            throw URLError(.zeroByteResource)
        }

        // Convert to UIImage
        guard let image = UIImage(data: data) else {
            Self.logger.error("Image download failed for \(url.absoluteString, privacy: .public): invalid image data")
            throw URLError(.cannotDecodeContentData)
        }

        Self.logger.info("Image downloaded from \(url.absoluteString, privacy: .public): size=\(data.count) bytes in \(elapsedMS, format: .fixed(precision: 2)) ms")

        // Update metrics and publish (class is @MainActor isolated)
        self.totalMemory += data.count
        self.totalCount += 1
        if elapsedMS > self.maxElapsedMS {
            self.maxElapsedMS = elapsedMS
        }
        self.displayInfo.onNext(DisplayInfo(memory: self.totalMemory, time: self.maxElapsedMS, count: self.totalCount))

        return image
    }
    
    public func clearData() {
        totalMemory = 0
        maxElapsedMS = 0
        totalCount = 0
    }
}
