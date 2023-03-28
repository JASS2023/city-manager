//
//  WebSocketMessage.swift
//  JASS 2023 Smart City
//
//  Created by sunny wang on 2023/3/27.
//

import Foundation

struct WebSocketMessage: Codable {
    let topic: String
    let data: String
    
    func toJSONString() -> String {
        let encoder = JSONEncoder()
        let jsonData = try! encoder.encode(self)
        return String(data: jsonData, encoding: .utf8)!
    }
}

enum Topics: String {
    case PlanConstructionSite = "plan_construction_site"
    case StatusConstructionSite = "status_construction_site"
    case StatusTrafficLight = "status_traffic_light"
    case PlanTimeSensitiveService = "plan_service"
    case StatusService = "status_serivce"
    case StatusObstacle = "status_obstacle"
    case StatusVehicle = "status_vehicle"
}
