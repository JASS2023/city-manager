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
    var obstacles: [Obstacle]
    
    var image: Image {
        TileType.citizens.image
    }
    
    init(i: Int, j: Int, obstacles: [Obstacle]) {
        self.obstacles = obstacles
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
    public static var defaultObstacle: ObstacleCell {
        .init(i: 3, j: 7, obstacles: [.defaultObstacle])
    }
}

class Obstacle: Equatable, Hashable, Identifiable {
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
    
    static func == (lhs: Obstacle, rhs: Obstacle) -> Bool {
        lhs.id == rhs.id && lhs.i == rhs.i && lhs.j == rhs.j && lhs.yaw == rhs.yaw
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(i)
        hasher.combine(j)
        hasher.combine(yaw)
    }
}

extension Obstacle {
    public static var defaultObstacle: Obstacle {
        .init(id: 123, i: 3.4, j: 7.2, yaw: 10)
    }
}
