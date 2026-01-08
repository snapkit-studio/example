//
//  TagPresentationModel.swift
//  Feature
//
//  Created by 김재한 on 10/2/25.
//

import Foundation
import HomeDomain

public struct TagPresentationModel: Hashable, Sendable {
    public let id: Int
    public let name: String
    public let isSelected: Bool
    
    public init(id: Int, tag: Tag, selctedID: Int = PlaceType.whole.rawValue) {
        self.id = id
        self.name = tag.name
        self.isSelected = self.id == selctedID
    }
}
