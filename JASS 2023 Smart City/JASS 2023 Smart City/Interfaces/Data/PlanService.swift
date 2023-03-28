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
        let type: String
        let data: PlanServiceClass
    }

    // MARK: - PlanServiceClass
    struct PlanServiceClass: Codable {
        let message: String
        let serviceId: UUID
        let timestamp: Date
        let coordinates: [Coordinate]
        let timeConstraints: TimeConstraints
        let maximumSpeed: Double
    }

    // MARK: - Coordinate
    struct Coordinate: Codable {
        let x, y, quadrant: Int
    }

    // MARK: - TimeConstraints
    struct TimeConstraints: Codable {
        let start, end: String
    }

}
