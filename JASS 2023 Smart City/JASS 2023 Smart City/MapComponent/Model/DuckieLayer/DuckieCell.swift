//
//  DuckieCell.swift
//  JASS 2023 Smart City
//
//  Created by Philipp Zagar on 27.03.23.
//

import Foundation
import SwiftUI

class DuckieCell: Cell, Equatable, Hashable, Identifiable {
    @Published var id = UUID()
    @Published var duckies: [Duckie]
    
    var image: Image {
        TileType.duckie.image
    }
    
    init(i: Int, j: Int, duckies: [Duckie] = []) {
        self.duckies = duckies
        super.init(i: i, j: j)
    }
    
    static func == (lhs: DuckieCell, rhs: DuckieCell) -> Bool {
        lhs.i == rhs.i && lhs.j == rhs.j && lhs.duckies == rhs.duckies && lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(i)
        hasher.combine(j)
        hasher.combine(duckies)
        hasher.combine(id)
    }
}

extension DuckieCell {
    public static var defaultTile: DuckieCell {
        DuckieCell(i: 8, j: 11)
    }
}

class Duckie: Equatable, Hashable, Identifiable {
    @Published var id: Int
    @Published var i: Double
    @Published var j: Double
    @Published var yaw: Double
    
    init(id: Int, i: Double, j: Double, yaw: Double) {
        self.id = id
        self.i = i
        self.j = j
        self.yaw = yaw
    }
    
    static func == (lhs: Duckie, rhs: Duckie) -> Bool {
        lhs.id == rhs.id && lhs.i == rhs.i && lhs.j == rhs.j && lhs.yaw == rhs.yaw
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(i)
        hasher.combine(j)
        hasher.combine(yaw)
    }
}
