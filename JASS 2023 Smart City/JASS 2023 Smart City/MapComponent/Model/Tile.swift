//
//  Tile.swift
//  JASS 2023 Smart City
//
//  Created by Philipp Zagar on 27.03.23.
//

import Foundation
import Yams

// Define the TileType enum
enum TileType: String, Codable {
    case asphalt
    case straight
    case threeWay = "3way"
    case curve
}

// Define the Tile data structure
struct Tile: Codable, Hashable {
    let i: Int
    let j: Int
    let type: TileType
    var yaw: Double?
}

extension Tile {
    public static var defaultTile: Tile {
        Tile(i: 0, j: 0, type: .asphalt)
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
