//
//  Tile.swift
//  JASS 2023 Smart City
//
//  Created by Philipp Zagar on 27.03.23.
//

import Foundation
import Yams
import SwiftUI

// Define the Tile data structure
class TileCell: Cell, Equatable, Hashable {
    let type: TileType
    var yaw: Double?
    
    var image: Image {
        type.image
    }
    
    init(i: Int, j: Int, type: TileType, yaw: Double? = nil, quadrent: Quadrent = .none) {
        self.type = type
        self.yaw = yaw
        super.init(i: i, j: j, quadrent: quadrent)
    }
    
    static func == (lhs: TileCell, rhs: TileCell) -> Bool {
        lhs.i == rhs.i && lhs.j == rhs.j && lhs.type == rhs.type && lhs.yaw == rhs.yaw && lhs.quadrent == rhs.quadrent
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(i)
        hasher.combine(j)
        hasher.combine(type)
        hasher.combine(yaw)
        hasher.combine(quadrent)
    }
}

extension TileCell {
    public static var defaultTile: TileCell {
        TileCell(i: 0, j: 0, type: .asphalt, quadrent: .none)
    }
}

// Define the Pose data structure for the second YAML file
struct Pose: Codable {
    let pitch: Double
    let roll: Double
    let x: Double
    let y: Double
    let yaw: Double
    let z: Double
}

// Define the Frame data structure for the second YAML file
struct Frame: Codable {
    let pose: Pose
    let relative_to: String
}
