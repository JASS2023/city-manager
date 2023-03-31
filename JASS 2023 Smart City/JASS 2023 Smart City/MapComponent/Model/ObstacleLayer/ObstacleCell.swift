//
//  ObstacleCell.swift
//  JASS 2023 Smart City
//
//  Created by sunny wang on 2023/3/31.
//

import Foundation
import SwiftUI

class ObstacleCell: Cell, Equatable, Hashable, Identifiable {
    var id: UUID = UUID()
    
    @Published var quadrants: [Quadrant] = []
    
    var image: Image {
        TileType.barrier.image
    }
    
    init(i: Int, j: Int, quadrants: [Quadrant]) {
        self.quadrants = quadrants
        super.init(i: i, j: j)
    }
    
    static func == (lhs: ObstacleCell, rhs: ObstacleCell) -> Bool {
        lhs.i == rhs.i && lhs.j == rhs.j && lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(i)
        hasher.combine(j)
        hasher.combine(id)
    }
}

extension ObstacleCell {
    public static var defaultTile: ObstacleCell {
        ObstacleCell(i: 8, j: 10, quadrants: [.none])
    }
}
