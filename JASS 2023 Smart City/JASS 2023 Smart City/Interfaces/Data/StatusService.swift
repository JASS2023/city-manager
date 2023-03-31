//
//  StatusService.swift
//  JASS 2023 Smart City
//
//  Created by Philipp Zagar on 31.03.23.
//

import Foundation

enum StatusService {
    // MARK: - PlanService
    struct StatusService: Codable {
        let type: Self.Message
        let data: StatusServiceClass
        
        enum Message: String, Codable {
            case status = "status_service"
        }
    }

    // MARK: - PlanServiceClass
    struct StatusServiceClass: Codable {
        let message: Self.Message
        let serviceId: UUID
        let timestamp: Date
        let coordinates: [Coordinate]
        let timeConstraints: TimeConstraints
        let maximumSpeed: Double
        
        enum Message: String, Codable {
            case built = "built_service"
            case removed = "removed_service"
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
