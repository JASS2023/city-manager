//
//  ConstructionCell.swift
//  JASS 2023 Smart City
//
//  Created by sunny wang on 2023/3/28.
//

import Foundation
import SwiftUI

class ConstructionCell: Cell, Equatable, Hashable, Identifiable {
    @Published var constructionSiteUUIDs: [UUID] = []
    @Published var trafficLightUUIDs: [UUID] = []
    var id: UUID = UUID()

    var image: Image {
        TileType.cone.image
    }
    
    init(i: Int, j: Int, constructionSiteUUIDs: [UUID] = [], trafficLightUUIDs: [UUID] = []) {
        super.init(i: i, j: j)
        self.constructionSiteUUIDs = constructionSiteUUIDs
        self.trafficLightUUIDs = trafficLightUUIDs
    }
    
    static func == (lhs: ConstructionCell, rhs: ConstructionCell) -> Bool {
        lhs.i == rhs.i && lhs.j == rhs.j && lhs.id == rhs.id && lhs.constructionSiteUUIDs == rhs.constructionSiteUUIDs && lhs.trafficLightUUIDs == rhs.trafficLightUUIDs
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(i)
        hasher.combine(j)
        hasher.combine(id)
        hasher.combine(constructionSiteUUIDs)
        hasher.combine(trafficLightUUIDs)
    }
}

extension ConstructionCell {
    public static var defaultTile: ConstructionCell {
        ConstructionCell(i: 8, j: 10)
    }
}
