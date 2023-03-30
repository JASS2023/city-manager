//
//  CityModel.swift
//  JASS 2023 Smart City
//
//  Created by Philipp Zagar on 27.03.23.
//

import Foundation

@MainActor
class CityModel: ObservableObject {
    static var shared = CityModel()
    var mqtt: MQTT? = nil
    
    private init() {}
    
    @Published var map: LayeredMap = .init(layers: [])
    
    /*
    func updateView(cell: Cell) {
        var layer: Layer?
        if cell is DuckieCell {
            layer = self.map.getLayer() as? DuckieLayer
        } else if cell is ConstructionCell {
            layer = self.map.getLayer() as? ConstructionLayer
        }
        
        guard let layer else {
            return
        }
        
       // layer.addNewCell(cell: <#T##Cell#>)
    }
     */
    
    @MainActor
    // Only works on this level
    func trigger() {
        Task {
            self.objectWillChange.send()
            //self.map.objectWillChange.send()
        }
    }
}
