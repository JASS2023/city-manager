//
//  MapLayer.swift
//  JASS 2023 Smart City
//
//  Created by Philipp Zagar on 27.03.23.
//

import Foundation

class MapLayer: Layer {
    typealias Cell = Tile
    
    var data: [Cell]
    var name: String
    var overrideLowerLayers: Bool
    
    init(data: [Cell], overrideLowerLayers: Bool) {
        self.data = data
        self.name = "map layer"
        self.overrideLowerLayers = overrideLowerLayers
    }
}
