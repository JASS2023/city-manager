//
//  ConstructionCell.swift
//  JASS 2023 Smart City
//
//  Created by sunny wang on 2023/3/28.
//

import Foundation
import SwiftUI

class ConstructionCell: Cell, Equatable, Hashable, Identifiable {
    var id: UUID = UUID()
    
    @Published var constructionSiteUUID: UUID
    @Published var trafficLightUUIDs: [UUID] = []
    @Published var quadrants: [Quadrant] = []

    var image: Image {
        TileType.cone.image
    }
    
    init(i: Int, j: Int, constructionSiteUUID: UUID = .init(), quadrants: [Quadrant], trafficLightUUIDs: [UUID] = []) {
        self.constructionSiteUUID = constructionSiteUUID
        self.trafficLightUUIDs = trafficLightUUIDs
        self.quadrants = quadrants
        super.init(i: i, j: j)
    }
    
    static func == (lhs: ConstructionCell, rhs: ConstructionCell) -> Bool {
        lhs.i == rhs.i && lhs.j == rhs.j && lhs.id == rhs.id && lhs.constructionSiteUUID == rhs.constructionSiteUUID && lhs.trafficLightUUIDs == rhs.trafficLightUUIDs
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(i)
        hasher.combine(j)
        hasher.combine(id)
        hasher.combine(constructionSiteUUID)
        hasher.combine(trafficLightUUIDs)
    }
}

extension ConstructionCell {
    public static var defaultTile: ConstructionCell {
        ConstructionCell(i: 8, j: 10, quadrants: [.none])
    }
}
