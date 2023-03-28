//
//  DuckieLayer.swift
//  JASS 2023 Smart City
//
//  Created by Philipp Zagar on 27.03.23.
//

import Foundation

class DuckieLayer: Layer {
    typealias CellType = DuckieCell
    
    @Published var data: [CellType]
    @Published var name: String
    @Published var overrideLowerLayers: Bool
    
    init(data: [CellType], overrideLowerLayers: Bool = false) {
        self.data = data
        self.name = "duckie layer"
        self.overrideLowerLayers = overrideLowerLayers
    }
}
