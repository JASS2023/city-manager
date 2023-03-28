//
//  DuckieCell.swift
//  JASS 2023 Smart City
//
//  Created by Philipp Zagar on 27.03.23.
//

import Foundation
import SwiftUI

class DuckieCell: Cell, Equatable, Hashable {
    @Published var yaw: Double?
    @Published var duckieUUIDs: [UUID] = []
    
    var image: Image {
        TileType.duckie.image
    }
    
    init(i: Int, j: Int, yaw: Double? = nil, quadrent: Quadrent = .none, duckieUUIDs: [UUID] = []) {
        super.init(i: i, j: j, quadrent: quadrent)
        self.yaw = yaw
        self.duckieUUIDs = duckieUUIDs
    }
    
    static func == (lhs: DuckieCell, rhs: DuckieCell) -> Bool {
        lhs.i == rhs.i && lhs.j == rhs.j && lhs.yaw == rhs.yaw && lhs.quadrent == rhs.quadrent
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(i)
        hasher.combine(j)
        hasher.combine(yaw)
        hasher.combine(quadrent)
    }
}

extension DuckieCell {
    public static var defaultTile: DuckieCell {
        DuckieCell(i: 8, j: 11, quadrent: .none)
    }
}
