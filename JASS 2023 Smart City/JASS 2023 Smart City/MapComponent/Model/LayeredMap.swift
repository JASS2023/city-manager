//
//  LayeredMap.swift
//  JASS 2023 Smart City
//
//  Created by Philipp Zagar on 27.03.23.
//

import Foundation
import SwiftUI

class LayeredMap: ObservableObject {
    let layers: [Int : any Layer] = [:]
}

protocol Layer: ObservableObject {
    associatedtype Cell
    
    var data: [Cell] { get }
    var name: String { get }
    var overrideLowerLayers: Bool { get }
}

protocol Cell: ObservableObject {
    var i: Int { get }
    var j: Int { get }
    var quadrent: Quadrent { get }
}

enum Quadrent: Int, Codable, Equatable, Hashable {
    case none = 0
    case upperRight = 1
    case upperLeft = 2
    case lowerLeft = 3
    case lowerRight = 4
}
