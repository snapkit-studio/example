//
//  ResponseModel+DomainMapping.swift
//  Data
//
//  Created by 김재한 on 9/30/25.
//

import Foundation
import CoreDomain
import HomeDomain
import DetailDomain
import RxSwift

// MARK: - Mapping Utilities

private enum Mapper {

    static func parseURL(_ string: String) -> URL? {
        URL(string: string)
    }
    
    static func parseRequiredDate(_ string: String) throws -> Date {
        // Create local formatters to avoid shared mutable state across concurrency domains
        let formatterWithFractional = ISO8601DateFormatter()
        formatterWithFractional.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let date = formatterWithFractional.date(from: string) {
            return date
        }

        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        if let date = formatter.date(from: string) {
            return date
        }

        throw DecodingError.dataCorrupted(
            DecodingError.Context(codingPath: [], debugDescription: "Invalid date string.")
        )
    }

    static func parseOptionalDate(_ string: String?) -> Date? {
        guard let string else { return nil }
        
        let formatterWithFractional = ISO8601DateFormatter()
        formatterWithFractional.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let date = formatterWithFractional.date(from: string) {
            return date
        }

        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        return formatter.date(from: string)
    }
}

// MARK: - Banner

extension BannerResponseModel {
    func toDomain() -> Banner {
        Banner(message: bannerMessage)
    }
}

// MARK: - Categories

extension CategoryResponseModel {
    func toDomain() -> [HomeDomain.HomeCategory] {
        cotegories.map { item in
            let url = Mapper.parseURL(item.imageURL)
            return HomeDomain.HomeCategory(imageURL: url, title: item.title)
        }
    }
}

// MARK: - Curations

extension CurationsResponseModel {
    func toDomain() -> [HomeDomain.Curation] {
        curations.map { curation in
            HomeDomain.Curation(
                title: curation.title,
                info: curation.items.map({ item in
                    HomeDomain.CurationInfo(
                        title: item.title,
                        imageURL: Mapper.parseURL(item.imageURL),
                        tags: item.tags,
                        participantCount: item.participantCount,
                        endedAt: item.endedAt.flatMap(Mapper.parseOptionalDate)
                    )
                })
            )
        }
    }
}

// MARK: - Places

extension PlacesResponseModel {
    func toDomain() -> [HomeDomain.Place] {
        place.map { item in
            let url = Mapper.parseURL(item.imageURL)
            let endedAt = item.endedAt.flatMap(Mapper.parseOptionalDate)
            return HomeDomain.Place(
                id: item.id,
                endedAt: endedAt,
                imageURL: url,
                participantCount: item.participantCount,
                tags: item.tags,
                title: item.title
            )
        }
    }
}

// MARK: - Detail

extension DetailResponseModel {
    func toDomain() -> Detail {
        let start = Mapper.parseOptionalDate(startAt)
        let end = Mapper.parseOptionalDate(endAt)
        
        return Detail(
            description: description,
            imageURLs: images.compactMap { Mapper.parseURL($0) },
            isParticipated: isParticipated,
            location: location,
            locationOpeningHourInfo: locationOpeningHourInfo,
            recommendCTAText: recommendCTAText,
            recommendDescription: recommendDescription,
            recommendTitle: recommendTitle,
            startAt: start,
            endAt: end,
            title: title
        )
    }
}

// MARK: - Tags

extension TagsResponseModel {
    func toDomain() -> [HomeDomain.Tag] {
        tags.map {
            HomeDomain.Tag(name: $0)
        }
    }
}

