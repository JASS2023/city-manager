//
//  ConstructionSIteData.swift
//  JASS 2023 Smart City
//
//  Created by sunny wang on 2023/3/27.
//

import Foundation

struct RequestConstructionSite: Codable {
    let id: UUID
    let coordinates: [Coordinate]
    let trafficLights: TrafficLights
    
    enum CodingKeys: String, CodingKey {
        case id
        case coordinates
        case trafficLights = "traffic_lights"
    }
}

struct RespondConstructionSite: Codable {
    let message: String
    let id: UUID
    let timestamp: Date
    let coordinates: [Coordinate]
}

struct Coordinate: Codable {
    let x: Int
    let y: Int
}

struct TrafficLights: Codable {
    let id1: UUID
    let id2: UUID
}
