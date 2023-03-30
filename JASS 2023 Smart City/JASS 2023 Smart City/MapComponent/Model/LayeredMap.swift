//
//  LayeredMap.swift
//  JASS 2023 Smart City
//
//  Created by Philipp Zagar on 27.03.23.
//

import Foundation
import SwiftUI

class LayeredMap: ObservableObject {
    @Published var layers: [Layer]
    
    init(layers: [Layer] = []) {
        self.layers = layers
    }
    
    func getLayer<L: Layer>() -> L {
        self.layers.first { layer in
            layer.self is L
        } as! L
    }
}

class Layer: ObservableObject {
    @Published var data: [Cell]
    @Published var name: String
    @Published var overrideLowerLayers: Bool
    
    init(data: [Cell], name: String, overrideLowerLayers: Bool) {
        self.data = data
        self.name = name
        self.overrideLowerLayers = overrideLowerLayers
    }
    
    func addNewCell(cell: Cell) {
        self.data.append(cell)
    }
}

class Cell: ObservableObject {
    @Published var i: Int
    @Published var j: Int
    
    init(i: Int, j: Int) {
        self.i = i
        self.j = j
    }
}

enum Quadrant: Int, Codable, Equatable, Hashable, Identifiable {
    var id: Self {
        return self
    }
    
    case none = 0
    case upperRight = 1
    case upperLeft = 2
    case lowerLeft = 3
    case lowerRight = 4
    
    var name: String {
        switch self {
        case .none: return "None"
        case .upperRight: return "Upper Right"
        case .upperLeft: return "Upper Left"
        case .lowerLeft: return "Lower Left"
        case .lowerRight: return "Lower Right"
        }
    }
    
    var coordinates: (Int, Int) {
        switch self {
        case .none: return (-1, -1)
        case .upperRight: return (1, 0)
        case .upperLeft: return (0, 0)
        case .lowerLeft: return (0, 1)
        case .lowerRight: return (1, 1)
        }
    }
}