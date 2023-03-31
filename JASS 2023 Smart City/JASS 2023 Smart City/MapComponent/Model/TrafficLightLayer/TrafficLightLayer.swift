//
//  TrafficLightLayer.swift
//  JASS 2023 Smart City
//
//  Created by Philipp Zagar on 31.03.23.
//

import Foundation

class TrafficLightLayer: Layer {
    typealias CellType = TrafficLightCell
    static let name = "traffic light layer"
    
    init(data: [CellType], overrideLowerLayers: Bool = false) {
        super.init(data: data, name: Self.name, overrideLowerLayers: overrideLowerLayers)
    }
}
