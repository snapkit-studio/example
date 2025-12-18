//
//  SectionPresentable.swift
//  DetailFeature
//
//  Created by 김재한 on 10/3/25.
//

import Foundation
import DetailDomain

public enum DetailSection: Hashable, Sendable {
    case images
    case info
}

public enum DetailItem: Hashable, Sendable {
    case image(DetailPresentation)
    case info(Detail)
}

public struct SectionPresenter: Hashable, Sendable {
    let detailSectoin: DetailSection
    let detailItems: [DetailItem]
    
    init(section: DetailSection, items: [DetailItem]) {
        self.detailSectoin = section
        self.detailItems = items
    }
    
    func section() -> DetailSection {
        detailSectoin
    }
    
    func items() -> [DetailItem] {
        detailItems
    }
}
