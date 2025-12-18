//
//  FeatureModelTests.swift
//  DataTests
//
//  Created by 김재한 on 9/30/25.
//

import Foundation
import Testing
import HomeDomain
import HomeFeature

@Suite("CurationInfo D-Day Tests")
struct CurationInfoDDayTests {
    
    // MARK: - Test Helpers
    
    private func createCurationInfo(
        title: String = "Test Event",
        daysFromNow: Int
    ) -> CurationInfo {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        // daysFromNow가 0이면 오늘 끝(23:59:59), 1이면 내일 끝에 설정
        let futureDate = calendar.date(byAdding: .day, value: daysFromNow, to: today)!
        let endOfDay = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: futureDate) ?? futureDate
        
        return CurationInfo(
            title: title,
            imageURL: nil,
            tags: [],
            participantCount: nil,
            endedAt: endOfDay
        )
    }
    
    // MARK: - dDayTitle 핵심 로직 테스트
    
    @Test("dDayTitle shows D-Day prefix for 0-30 days")
    func dDayTitleShowsPrefixFor30DaysOrLess() async throws {
        let title = "Test Event"
        
        // 0일 ~ 30일: D-Day prefix 포함
        let testCases = [0, 1, 15, 30]
        
        for days in testCases {
            let curationInfo = createCurationInfo(title: title, daysFromNow: days)
            let expected = "D-\(days) \(title)"
            
            #expect(
                curationInfo.dDayTitle == expected,
                "For \(days) days: expected '\(expected)', got '\(curationInfo.dDayTitle ?? "nil")'"
            )
        }
    }
    
    @Test("dDayTitle shows original title for 31+ days")
    func dDayTitleShowsOriginalTitleForMoreThan30Days() async throws {
        let title = "Test Event"
        
        // 31일 이상: 원본 title만
        let testCases = [31, 60, 100, 365]
        
        for days in testCases {
            let curationInfo = createCurationInfo(title: title, daysFromNow: days)
            
            #expect(
                curationInfo.dDayTitle == title,
                "For \(days) days: expected '\(title)', got '\(curationInfo.dDayTitle ?? "nil")'"
            )
        }
    }
}

@Suite("Place D-Day Tests")
struct PlaceDDayTests {
    
    // MARK: - Test Helpers
    
    private func createPlace(
        title: String = "Test Place",
        daysFromNow: Int
    ) -> Place {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        // daysFromNow가 0이면 오늘 끝(23:59:59), 1이면 내일 끝에 설정
        let futureDate = calendar.date(byAdding: .day, value: daysFromNow, to: today)!
        let endOfDay = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: futureDate) ?? futureDate
        
        return Place(
            id: nil,
            endedAt: endOfDay,
            imageURL: nil,
            participantCount: nil,
            tags: [],
            title: title
        )
    }
    
    // MARK: - dDay 핵심 로직 테스트
    
    @Test("dDay shows D-Day format for 0-30 days")
    func dDayShowsFormatFor30DaysOrLess() async throws {
        // 0일 ~ 30일: D-Day 형식
        let testCases = [0, 1, 15, 30]
        
        for days in testCases {
            let place = createPlace(daysFromNow: days)
            let expected = "D-\(days)"
            
            #expect(
                place.dDay == expected,
                "For \(days) days: expected '\(expected)', got '\(place.dDay)'"
            )
        }
    }
    
    // MARK: - dDayTitle 핵심 로직 테스트
    
    @Test("dDayTitle shows D-Day prefix for 0-30 days")
    func dDayTitleShowsPrefixFor30DaysOrLess() async throws {
        let title = "Test Place"
        
        // 0일 ~ 30일: D-Day prefix 포함
        let testCases = [0, 1, 15, 30]
        
        for days in testCases {
            let place = createPlace(title: title, daysFromNow: days)
            let expected = "D-\(days) \(title)"
            
            #expect(
                place.dDayTitle == expected,
                "For \(days) days: expected '\(expected)', got '\(place.dDayTitle ?? "nil")'"
            )
        }
    }
    
    @Test("dDayTitle shows original title for 31+ days")
    func dDayTitleShowsOriginalTitleForMoreThan30Days() async throws {
        let title = "Test Place"
        
        // 31일 이상: 원본 title만
        let testCases = [31, 60, 100, 365]
        
        for days in testCases {
            let place = createPlace(title: title, daysFromNow: days)
            
            #expect(
                place.dDayTitle == title,
                "For \(days) days: expected '\(title)', got '\(place.dDayTitle ?? "nil")'"
            )
        }
    }
}
