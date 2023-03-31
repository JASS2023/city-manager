//
//  StatusObstacle.swift
//  JASS 2023 Smart City
//
//  Created by sunny wang on 2023/3/31.
//

import Foundation

enum StatusObstacle {
    struct StatusObstacle: Codable {
        let type: String
        let data: ObstacleData
    }
    
    struct ObstacleData: Codable {
        let message: String
        let id: Int
        let timestamp: String
        let label: String
        let duckieId: Int
        let `case`: String
    }
    
    
    
}
