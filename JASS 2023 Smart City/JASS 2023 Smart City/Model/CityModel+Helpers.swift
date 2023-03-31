//
//  CityModel+Helpers.swift
//  JASS 2023 Smart City
//
//  Created by Philipp Zagar on 29.03.23.
//

import Foundation

extension CityModel {
    // Conviniently access the tile cell layer
    var tileCells: [TileCell] {
        // Access the cell data of the layer
        guard self.map.layers.count > 1 else {
            return [];
        }
        
        let layer: TileLayer = self.map.getLayer()
        guard let tileCellData = layer.data as? [TileCell] else {
            return []
        }
        
        return tileCellData
    }
    
    // Conviniently access the constrcution cell layer
    var constructionCells: [ConstructionCell] {
        guard self.map.layers.count > 1 else {
            return [];
        }
        
        let layer: ConstructionLayer = self.map.getLayer()
        guard let constructionCellData = layer.data as? [ConstructionCell] else {
            return []
        }
        
        return constructionCellData
    }
    
    // Conviniently access the service cell layer
    var serviceCells: [ServiceCell] {
        guard self.map.layers.count > 1 else {
            return [];
        }
        
        let layer: ServiceLayer = self.map.getLayer()
        guard let serivceCellsData = layer.data as? [ServiceCell] else {
            return []
        }
        
        return serivceCellsData
    }
    
    // Conviniently access the traffic light cell layer
    var trafficCells: [TrafficLightCell] {
        guard self.map.layers.count > 1 else {
            return [];
        }
        
        let layer: TrafficLightLayer = self.map.getLayer()
        guard let trafficLightCellsData = layer.data as? [TrafficLightCell] else {
            return []
        }
        
        return trafficLightCellsData
    }
    
    // Conviniently access the obstacle cell layer
    var obstacleCells: [ObstacleCell] {
        guard self.map.layers.count > 1 else {
            return [];
        }
        
        let layer: ObstacleLayer = self.map.getLayer()
        guard let obstacleCellsData = layer.data as? [ObstacleCell] else {
            return []
        }
        
        return obstacleCellsData
    }
}
