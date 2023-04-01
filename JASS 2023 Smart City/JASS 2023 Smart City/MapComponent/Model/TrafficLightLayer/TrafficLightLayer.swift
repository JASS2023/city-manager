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
    
    func update(id: Int, statusLightData: StatusLight.StatusLight) {
        guard var data = self.data as? [TrafficLightCell], 1 <= id && id <= 2 else {
            return
        }
        
        let light: TrafficLightCell = (id == 1) ? .defaultTrafficLight : .defaultTrafficLight2
        
        data[id - 1] = .init(i: light.trafficLight.i, j: light.trafficLight.j, trafficLight: statusLightData.data.color)
        
        self.data = data
    }
}
