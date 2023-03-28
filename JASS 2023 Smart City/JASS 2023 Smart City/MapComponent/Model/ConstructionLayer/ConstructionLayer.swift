//
//  ConstructionLayer.swift
//  JASS 2023 Smart City
//
//  Created by sunny wang on 2023/3/28.
//

import Foundation
class ConstructionLayer: Layer {
    typealias CellType = ConstructionCell
    static let name = "construction layer"

    init(data: [CellType], overrideLowerLayers: Bool = false) {
        super.init(data: data, name: Self.name, overrideLowerLayers: overrideLowerLayers)
    }
}
