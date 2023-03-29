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
        // Access the cell data of the layer
        
        guard self.map.layers.count > 1 else {
            return [];
        }
        
        let layer: ConstructionLayer = self.map.getLayer()
        guard let constructionCellData = layer.data as? [ConstructionCell] else {
            return []
        }
        
        return constructionCellData
    }
}
