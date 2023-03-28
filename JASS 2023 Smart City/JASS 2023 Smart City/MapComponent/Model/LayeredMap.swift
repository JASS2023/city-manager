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
}

class Cell: ObservableObject {
    @Published var i: Int
    @Published var j: Int
    @Published var quadrent: Quadrent
    
    init(i: Int, j: Int, quadrent: Quadrent) {
        self.i = i
        self.j = j
        self.quadrent = quadrent
    }
}

/*
protocol Layer: ObservableObject {
    associatedtype CellType: Cell
    
    var data: [CellType] { get }
    var name: String { get }
    var overrideLowerLayers: Bool { get }
}
 */

/*
protocol Cell: ObservableObject {
    var i: Int { get }
    var j: Int { get }
    var quadrent: Quadrent { get }
}
 */

enum Quadrent: Int, Codable, Equatable, Hashable {
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
}
