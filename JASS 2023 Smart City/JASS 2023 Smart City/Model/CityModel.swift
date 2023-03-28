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
    
    @Published var tiles: [String : TileCell] = [:]
    @Published var map: LayeredMap = .init(layers: [:])
    
    // Conviniently access the tile cell layer
    var tileCells: [TileCell] {
              // Access the first layer
        guard let tileIndex = self.map.layers.keys.sorted(by: <).first,
              // Access the cell data of the layer
              let tileRawData = self.map.layers[tileIndex]?.data,
              // Parse it to a respective format
              let tileCellData = tileRawData as? [TileCell] else {
            return []
        }
        
        return tileCellData
    }
    
    // Conviniently access the duckie cell layer
    var duckieCells: [DuckieCell] {
              // Access the first layer
        guard let duckieIndex = self.map.layers.keys.sorted(by: <).last,
              // Access the cell data of the layer
              let duckieRawData = self.map.layers[duckieIndex]?.data,
              // Parse it to a respective format
              let duckieCellData = duckieRawData as? [DuckieCell] else {
            return []
        }
        
        return duckieCellData
    }
}
