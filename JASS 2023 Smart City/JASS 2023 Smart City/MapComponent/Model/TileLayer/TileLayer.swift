//
//  MapLayer.swift
//  JASS 2023 Smart City
//
//  Created by Philipp Zagar on 27.03.23.
//

import Foundation

class TileLayer: Layer {
    typealias CellType = TileCell
    
    init(data: [CellType], overrideLowerLayers: Bool = false) {
        super.init(data: data, name: "tile layer", overrideLowerLayers: overrideLowerLayers)
    }
}
