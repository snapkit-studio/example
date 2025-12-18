//
//  SectionPresentable.swift
//  Feature
//
//  Created by 김재한 on 10/1/25.
//

import Foundation
import HomeDomain

public enum HomeSection: Hashable, Sendable {
    case banner
    case categories
    case categoriesDivider
    case curationsHeader(id: UUID = UUID())
    case curations(id: UUID = UUID())
    case curationsDivider(id: UUID = UUID())
    case placeDivider 
    case places
}

public enum HomeItem: Hashable, Sendable {
    case banner(Banner)
    case category([HomeCategoryPresentation])
    case curationHeader(String)
    case curation(CurationInfoPresentation)
    case curationDivider
    case divider
    case placeDivider
    case place(PlacePresentation)
}

public struct SectionPresenter: Hashable, Sendable {
    
    let homeSection: HomeSection
    let homeItem: [HomeItem]
    
    init(homeSection: HomeSection, homeItems: [HomeItem]) {
        self.homeSection = homeSection
        self.homeItem = homeItems
    }
    
    func section() -> HomeSection {
        homeSection
    }
    
    func items() -> [HomeItem] {
        homeItem
    }
}
