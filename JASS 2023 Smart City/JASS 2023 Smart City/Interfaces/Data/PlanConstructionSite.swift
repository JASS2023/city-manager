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
        let type: Self.Message
        let data: ConstructionSite
        
        enum Message: String, Codable {
            case plan = "plan_construction_site"
        }
    }

    // MARK: - ConstructionSite
    struct ConstructionSite: Codable {
        let id: UUID
        let coordinates: [Coordinate]
        let startDateTime, endDateTime: Date
        let maximumSpeed: Double
        let trafficLights: TrafficLights?
    }

    // MARK: - Coordinate
    struct Coordinate: Codable {
        let x, y: Int
        let quadrants: [Quadrant]
        let x_abs, y_abs: Double
    }

    // MARK: - TrafficLights
    struct TrafficLights: Codable {
        let id1, id2: UUID
    }
    
    // MARK: - ConstructionTime
    struct ConstructionTime: Codable, Hashable, Equatable {
        let start, end: Date
    }
    
}

