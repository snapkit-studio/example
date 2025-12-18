//
//  ResponseToDomainTests.swift
//  DataTests
//
//  Created by 김재한 on 9/30/25.
//

import Foundation
import Testing
@testable import Data
@testable import HomeDomain
@testable import DetailDomain

// MARK: - Banner
@Suite("BannerResponseModel toDomain")
struct BannerToDomainTests {
    @Test("Maps banner message")
    func mapsBanner() {
        let response = BannerResponseModel(bannerMessage: "Hello")
        let domain = response.toDomain()
        #expect(domain.message == "Hello")
    }
}


// MARK: - Categories
@Suite("CategoryResponseModel toDomain")
struct CategoryToDomainTests {
    @Test("Maps categories including URL parsing")
    func mapsCategories() throws {
        let items: [CategoryResponseModel.Category] = [
            .init(imageURL: "https://example.com/a.png", title: "전체"),
            .init(imageURL: "not-a-url", title: "잘못된 URL")
        ]
        let response = CategoryResponseModel(cotegories: items)

        let domain = response.toDomain()
        #expect(domain.count == 2)

        let first = try #require(domain.first)
        #expect(first.title == "전체")
        #expect(first.imageURL == URL(string: "https://example.com/a.png"))

        let last = try #require(domain.last)
        #expect(last.title == "잘못된 URL")
        #expect(last.imageURL?.host() == nil || last.imageURL?.scheme == nil)
    }
}


// MARK: - Curations
@Suite("CurationsResponseModel toDomain")
struct CurationsToDomainTests {
    @Test("Maps curations including URL and date parsing")
    func mapsCurations() throws {
        // Given
        let firstCurationItems: [CurationsResponseModel.Item] = [
            .init(
                imageURL: "https://example.com/a.png",
                title: "A",
                tags: ["서울", "카페"],
                participantCount: 3,
                endedAt: "2025-07-16T15:00:00+00:00"
            ),
            .init(
                imageURL: "not-a-url",
                title: "B",
                tags: [],
                participantCount: nil,
                endedAt: nil
            ),
            .init(
                imageURL: "https://example.com/b.png",
                title: "C",
                tags: ["경기"],
                participantCount: nil,
                endedAt: "2026-07-16T15:00:00.123Z"
            )
        ]
        let secondCurationItems: [CurationsResponseModel.Item] = [
            .init(
                imageURL: "https://example.com/c.png",
                title: "D",
                tags: ["모든 지역"],
                participantCount: 0,
                endedAt: nil
            )
        ]
        let response = CurationsResponseModel(curations: [
            .init(title: "인기 있는 장소", items: firstCurationItems),
            .init(title: "내 주변 놀거리", items: secondCurationItems)
        ])

        // When
        let domain = response.toDomain()

        // Then
        #expect(domain.count == 2)

        let first = try #require(domain.first)
        #expect(first.title == "인기 있는 장소")
        #expect(first.info.count == 3)

        let firstInfo = try #require(first.info.first)
        #expect(firstInfo.imageURL == URL(string: "https://example.com/a.png"))
        #expect(firstInfo.tags == ["서울", "카페"])
        #expect(firstInfo.participantCount == 3)
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        let expectedDate1 = formatter.date(from: "2025-07-16T15:00:00+00:00")
        #expect(firstInfo.endedAt == expectedDate1)

        let secondInfo = first.info[1]
        #expect(secondInfo.imageURL?.host() == nil || secondInfo.imageURL?.scheme == nil)
        #expect(secondInfo.tags.isEmpty)
        #expect(secondInfo.participantCount == nil)
        #expect(secondInfo.endedAt == nil)

        let thirdInfo = first.info[2]
        #expect(thirdInfo.imageURL == URL(string: "https://example.com/b.png"))
        let fractional = ISO8601DateFormatter()
        fractional.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        let expectedDate2 = fractional.date(from: "2026-07-16T15:00:00.123Z")
        #expect(thirdInfo.endedAt == expectedDate2)

        let last = try #require(domain.last)
        #expect(last.title == "내 주변 놀거리")
        #expect(last.info.count == 1)

        let only = try #require(last.info.first)
        #expect(only.imageURL == URL(string: "https://example.com/c.png"))
        #expect(only.tags == ["모든 지역"])
        #expect(only.participantCount == 0)
        #expect(only.endedAt == nil)
    }
}


// MARK: - Places
@Suite("PlacesResponseModel toDomain")
struct PlacesToDomainTests {
    @Test("Maps places including URL and date parsing")
    func mapsPlaces() throws {
        // Given
        let items: [PlacesResponseModel.Place] = [
            .init(
                id: nil,
                endedAt: nil,
                imageURL: "https://example.com/one.png",
                participantCount: 15,
                tags: ["서울", "카페"],
                title: "룸서비스 301"
            ),
            .init(
                id: 42,
                endedAt: "2025-07-20T15:00:00+00:00",
                imageURL: "https://example.com/two.png",
                participantCount: 1,
                tags: ["서울", "카페"],
                title: "블루보틀 제주"
            ),
            .init(
                id: nil,
                endedAt: "2026-07-16T15:00:00.123Z",
                imageURL: "not-a-url",
                participantCount: nil,
                tags: [],
                title: "잘못된 URL"
            )
        ]
        let response = PlacesResponseModel(place: items)

        // When
        let domain = response.toDomain()

        // Then
        #expect(domain.count == 3)

        let first = try #require(domain.first)
        #expect(first.id == nil)
        #expect(first.title == "룸서비스 301")
        #expect(first.imageURL == URL(string: "https://example.com/one.png"))
        #expect(first.participantCount == 15)
        #expect(first.endedAt == nil)
        #expect(first.tags == ["서울", "카페"])

        let second = domain[1]
        #expect(second.id == 42)
        #expect(second.title == "블루보틀 제주")
        #expect(second.imageURL == URL(string: "https://example.com/two.png"))
        #expect(second.participantCount == 1)
        let iso = ISO8601DateFormatter()
        iso.formatOptions = [.withInternetDateTime]
        let expectedEndedAt = iso.date(from: "2025-07-20T15:00:00+00:00")
        #expect(second.endedAt == expectedEndedAt)
        #expect(second.tags == ["서울", "카페"])

        let third = try #require(domain.last)
        #expect(third.id == nil)
        #expect(third.title == "잘못된 URL")
        
        #expect(third.imageURL?.host() == nil || third.imageURL?.scheme == nil)
        #expect(third.participantCount == nil)
        let isoFractional = ISO8601DateFormatter()
        isoFractional.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        let expectedEndedAtFractional = isoFractional.date(from: "2026-07-16T15:00:00.123Z")
        #expect(third.endedAt == expectedEndedAtFractional)
        #expect(third.tags.isEmpty)
    }
}


// MARK: - Detail
@Suite("DetailResponseModel toDomain")
struct DetailToDomainTests {
    @Test("Maps detail fields and parses dates")
    func mapsDetail() {
        // Given
        let response = DetailResponseModel(
            description: "전시 설명",
            endAt: "2025-07-16T15:00:00+00:00",
            images: [
                "https://example.com/1.png",
                "not-a-url"
            ],
            isParticipated: true,
            location: "서울 어딘가",
            locationOpeningHourInfo: "매일 10:00 ~ 18:00",
            recommendCTAText: "관심 있어요",
            recommendDescription: "'관심 있어요'를 눌러서 같이 갈만한 친구들을 확인해보세요!",
            recommendTitle: "이곳을 가고 싶어 하는 친구",
            startAt: "2023-05-23T15:00:00.123Z",
            title: "요시다 유니 : Alchemy"
        )

        // When
        let domain = response.toDomain()

        // Then: simple fields
        #expect(domain.description == "전시 설명")
        #expect(domain.title == "요시다 유니 : Alchemy")
        #expect(domain.isParticipated == true)
        #expect(domain.location == "서울 어딘가")
        #expect(domain.locationOpeningHourInfo == "매일 10:00 ~ 18:00")
        #expect(domain.recommendCTAText == "관심 있어요")
        #expect(domain.recommendDescription == "'관심 있어요'를 눌러서 같이 갈만한 친구들을 확인해보세요!")
        #expect(domain.recommendTitle == "이곳을 가고 싶어 하는 친구")

        // dates
        let fractional = ISO8601DateFormatter()
        fractional.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        let expectedStart = fractional.date(from: "2023-05-23T15:00:00.123Z")
        #expect(domain.startAt == expectedStart)

        let plain = ISO8601DateFormatter()
        plain.formatOptions = [.withInternetDateTime]
        let expectedEnd = plain.date(from: "2025-07-16T15:00:00+00:00")
        #expect(domain.endAt == expectedEnd)
    }

    @Test("Handles nil dates and empty images")
    func handlesNilDates() {
        // Given
        let response = DetailResponseModel(
            description: "설명",
            endAt: nil,
            images: [],
            isParticipated: false,
            location: "위치",
            locationOpeningHourInfo: "영업시간",
            recommendCTAText: "CTA",
            recommendDescription: "추천 설명",
            recommendTitle: "추천 타이틀",
            startAt: nil,
            title: "제목"
        )

        // When
        let domain = response.toDomain()

        // Then
        #expect(domain.startAt == nil)
        #expect(domain.endAt == nil)
        #expect(domain.imageURLs.isEmpty)
        #expect(domain.title == "제목")
        #expect(domain.isParticipated == false)
    }
}
