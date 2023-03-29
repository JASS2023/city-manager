//
//  DuckieModel.swift
//  JASS 2023 Smart City
//
//  Created by Philipp Zagar on 29.03.23.
//

import Foundation

class DuckieModel: ObservableObject {
    static var shared = DuckieModel()
    
    @Published var duckieMap: DuckieLayer = .init(data: [])
    
    // Conviniently access the duckie cell layer
    var duckieCells: [DuckieCell] {
        // Access the cell data of the layer
        return self.duckieMap.data as? [DuckieCell] ?? []
    }
    
    @MainActor
    // Only works on this level
    func trigger() {
        self.objectWillChange.send()
        self.duckieMap.objectWillChange.send()
    }
}
