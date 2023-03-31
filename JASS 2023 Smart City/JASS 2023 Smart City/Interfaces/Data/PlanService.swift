//
//  PlanService.swift
//  JASS 2023 Smart City
//
//  Created by Philipp Zagar on 28.03.23.
//

import Foundation

enum PlanService {
    // MARK: - PlanService
    struct PlanService: Codable {
        let type: Self.Message
        let data: PlanServiceClass
        
        enum Message: String, Codable {
            case plan = "plan_service"
        }
    }

    // MARK: - PlanServiceClass
    struct PlanServiceClass: Codable {
        let message: Self.Message
        let serviceId: UUID
        let timestamp: Date
        let coordinates: [Coordinate]
        let timeConstraints: TimeConstraints
        let maximumSpeed: Double
        
        enum Message: String, Codable {
            case planned = "planned_service"
        }
    }

    // MARK: - Coordinate
    struct Coordinate: Codable, Hashable, Equatable {
        let x, y: Int
        let quadrant: Quadrant
    }

    // MARK: - TimeConstraints
    struct TimeConstraints: Codable, Hashable, Equatable {
        let start, end: Date
    }
}
