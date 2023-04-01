//
//  TrafficLightCell.swift
//  JASS 2023 Smart City
//
//  Created by Philipp Zagar on 31.03.23.
//

import Foundation
import SwiftUI

class TrafficLightCell: Cell, Equatable, Hashable, Identifiable {
    var id: UUID = UUID()
    let trafficLight: TrafficLight
    
    init(i: Double, j: Double, trafficLight: StatusLight.DataClass.LightColor) {
        switch trafficLight {
        case .yellow: self.trafficLight = .init(color: .yellow, i: i, j: j)
        case .red: self.trafficLight = .init(color: .red, i: i, j: j)
        case .green: self.trafficLight = .init(color: .green, i: i, j: j)
        case .prepare: self.trafficLight = .init(color: .prepare, i: i, j: j)
        }
        super.init(i: Int(i), j: Int(j))
    }
    
    static func == (lhs: TrafficLightCell, rhs: TrafficLightCell) -> Bool {
        lhs.i == rhs.i && lhs.j == rhs.j && lhs.id == rhs.id && lhs.trafficLight == rhs.trafficLight
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(i)
        hasher.combine(j)
        hasher.combine(id)
        hasher.combine(trafficLight)
    }
}

extension TrafficLightCell {
    public static var defaultTrafficLight: TrafficLightCell {
        TrafficLightCell(i: 4.85, j: 8.9, trafficLight: .red)
    }
    
    public static var defaultTrafficLight2: TrafficLightCell {
        TrafficLightCell(i: 4.4, j: 7.89, trafficLight: .green)
    }
}

struct TrafficLight: Equatable, Hashable {
    let color: StatusLight.DataClass.LightColor
    let i: Double
    let j: Double
}
