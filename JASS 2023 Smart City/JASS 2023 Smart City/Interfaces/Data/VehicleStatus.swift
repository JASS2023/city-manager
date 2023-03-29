//
//  VehicleStatus.swift
//  JASS 2023 Smart City
//
//  Created by Philipp Zagar on 29.03.23.
//

import Foundation

enum VehicleStatus {
    // MARK: - VehicleStatus
    struct VehicleStatus: Codable {
        let type: String
        let data: DataClass
    }

    // MARK: - DataClass
    struct DataClass: Codable {
        let id: Int
        let name: String
        let timestamp: Date
        let coordinates: Coordinates
    }

    // MARK: - Coordinates
    struct Coordinates: Codable {
        let x, y, yaw: Double
        let xAbs, yAbs: Double
    }
}
