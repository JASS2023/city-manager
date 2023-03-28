//
//  DuckieCell.swift
//  JASS 2023 Smart City
//
//  Created by Philipp Zagar on 27.03.23.
//

import Foundation
import SwiftUI

class DuckieCell: Cell, Codable, Equatable, Hashable {
    let i: Int
    let j: Int
    var yaw: Double?
    let quadrent: Quadrent
    var duckieUUIDs: [UUID] = []
    
    var image: Image {
        .init("DuckieBot")
    }
    
    init(i: Int, j: Int, yaw: Double? = nil, quadrent: Quadrent = .none) {
        self.i = i
        self.j = j
        self.yaw = yaw
        self.quadrent = quadrent
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
        DuckieCell(i: 0, j: 0, quadrent: .none)
    }
}
