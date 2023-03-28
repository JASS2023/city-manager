//
//  DuckieLayer.swift
//  JASS 2023 Smart City
//
//  Created by Philipp Zagar on 27.03.23.
//

import Foundation

class DuckieLayer: Layer {
    typealias CellType = DuckieCell
    
    init(data: [CellType], overrideLowerLayers: Bool = false) {
        super.init(data: data, name: "duckie layer", overrideLowerLayers: overrideLowerLayers)
    }
}
