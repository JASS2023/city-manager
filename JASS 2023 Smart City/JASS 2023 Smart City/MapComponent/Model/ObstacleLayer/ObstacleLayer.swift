//
//  ObstacleLater.swift
//  JASS 2023 Smart City
//
//  Created by sunny wang on 2023/3/31.
//

import Foundation

class ObstacleLayer: Layer {
    typealias CellType = ObstacleCell
    static let name = "obstacle layer"
    
    init(data: [CellType], overrideLowerLayers: Bool = false) {
        super.init(data: data, name: Self.name, overrideLowerLayers: overrideLowerLayers)
    }
    
    func update(obstacleStatus: StatusObstacle.StatusObstacle) {
        guard let data = self.data as? [ObstacleCell] else {
            return
        }
        
        if obstacleStatus.data.message == "discover_obstacle" {
            switch obstacleStatus.data.case {
            case "left", "right", "close", "danger":
//            todo: show the obstacle
                break
            default:
//                do nothing
                break
            }
            self.data = data
        }
    }
}
