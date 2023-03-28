//
//  CityModel.swift
//  JASS 2023 Smart City
//
//  Created by Philipp Zagar on 27.03.23.
//

import Foundation

class CityModel: ObservableObject {
    static var shared = CityModel()
    static var interface: WebsocketConnection = WebsocketConnection()
    
    @Published var map: LayeredMap = .init(layers: [])
    
    // Only works on this level
    func trigger() {
        self.objectWillChange.send()
    }
    
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
        //        guard let tileLayer = self.map.layers.first, let tileRawData = tileLayer.data,
        //                // Parse it to a respective format
        //                let tileCellData = tileRawData as? [TileCell] else {
        //            return []
        //        }
        
        return tileCellData
    }
    
    // Conviniently access the duckie cell layer
    var duckieCells: [DuckieCell] {
        // Access the cell data of the layer
        
        guard self.map.layers.count > 1 else {
            return [];
        }
        
        let layer: DuckieLayer = self.map.getLayer()
        guard let duckieCellData = layer.data as? [DuckieCell] else {
            return []
        }
        
        return duckieCellData
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
