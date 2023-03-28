//
//  ConstructionCell.swift
//  JASS 2023 Smart City
//
//  Created by sunny wang on 2023/3/28.
//

import Foundation
import SwiftUI

class ConstructionCell: Cell, Equatable, Hashable {
    @Published var constructionSiteUUIDs: [UUID] = []
    @Published var trafficLightUUIDs: [UUID] = []

    var image: Image {
        TileType.cone.image
    }
    
    init(i: Int, j: Int, yaw: Double? = nil, quadrent: Quadrent = .none) {
        super.init(i: i, j: j, quadrent: quadrent)
    }
    
    static func == (lhs: ConstructionCell, rhs: ConstructionCell) -> Bool {
        lhs.i == rhs.i && lhs.j == rhs.j && lhs.quadrent == rhs.quadrent
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(i)
        hasher.combine(j)
        hasher.combine(quadrent)
    }
}

extension ConstructionCell {
    public static var defaultTile: ConstructionCell {
        ConstructionCell(i: 8, j: 10, quadrent: .none)
    }
}
