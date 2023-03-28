//
//  ConstructionSIteData.swift
//  JASS 2023 Smart City
//
//  Created by sunny wang on 2023/3/27.
//

import Foundation

enum PlanConstructionSite {
    // MARK: - PlanConstructionSite
    struct PlanConstructionSite: Codable {
        let type: String
        let data: DataClass
    }

    // MARK: - DataClass
    struct DataClass: Codable {
        let constructionSite: ConstructionSite
    }

    // MARK: - ConstructionSite
    struct ConstructionSite: Codable {
        let id: UUID
        let coordinates: [Coordinate]
        let startDateTime, endDateTime: Date
        let maximumSpeed: Double
        let trafficLights: TrafficLights
    }

    // MARK: - Coordinate
    struct Coordinate: Codable {
        let x, y, quadrant: Int
    }

    // MARK: - TrafficLights
    struct TrafficLights: Codable {
        let id1, id2: UUID
    }
}

