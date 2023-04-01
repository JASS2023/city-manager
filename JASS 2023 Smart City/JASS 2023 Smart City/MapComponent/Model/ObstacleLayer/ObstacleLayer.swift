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
        guard var data = self.data as? [ObstacleCell] else {
            return
        }
        
        switch obstacleStatus.data.message {
        case "discover_obstacle":
            data.append(
                .defaultObstacle
            )
        case "remove_obstacle":
            data.removeAll()
        default: break
        }

        self.data = data
    }
}
