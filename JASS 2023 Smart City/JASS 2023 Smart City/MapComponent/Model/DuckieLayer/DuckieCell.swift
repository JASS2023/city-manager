//
//  DuckieCell.swift
//  JASS 2023 Smart City
//
//  Created by Philipp Zagar on 27.03.23.
//

import Foundation
import SwiftUI

class DuckieCell: Cell, Equatable, Hashable {
    //@Published var i: Int
    //@Published var j: Int
    @Published var yaw: Double?
    //@Published var quadrent: Quadrent
    @Published var duckieUUIDs: [UUID] = []
    
    var image: Image {
        TileType.duckie.image
    }
    
    init(i: Int, j: Int, yaw: Double? = nil, quadrent: Quadrent = .none) {
        super.init(i: i, j: j, quadrent: quadrent)
        //self.i = i
        //self.j = j
        self.yaw = yaw
        //self.quadrent = quadrent
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
        DuckieCell(i: 10, j: 10, quadrent: .none)
    }
}
