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
        guard let tileRawData = self.map.layers.first?.data,
                // Parse it to a respective format
                let tileCellData = tileRawData as? [TileCell] else {
            return []
        }
        
        return tileCellData
    }
    
    // Conviniently access the duckie cell layer
    var duckieCells: [DuckieCell] {
        // Access the cell data of the layer
        guard let duckieRawData = self.map.layers.last?.data,
                // Parse it to a respective format
                let duckieCellData = duckieRawData as? [DuckieCell] else {
            return []
        }
        
        return duckieCellData
    }
}
