//
//  DuckieLayer.swift
//  JASS 2023 Smart City
//
//  Created by Philipp Zagar on 27.03.23.
//

import Foundation

class DuckieLayer: Layer {
    typealias CellType = DuckieCell
    
    static let name = "duckie layer"
    
    init(data: [CellType], overrideLowerLayers: Bool = false) {
        super.init(data: data, name: Self.name, overrideLowerLayers: overrideLowerLayers)
    }
}
