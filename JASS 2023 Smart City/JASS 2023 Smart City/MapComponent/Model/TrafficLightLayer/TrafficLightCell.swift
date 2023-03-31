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
    
    init(i: Int, j: Int, trafficLight: StatusLight.DataClass.LightColor) {
        switch trafficLight {
        case .yellow: self.trafficLight = .init(color: .yellow, i: 7.5, j: 7.5)
        case .red: self.trafficLight = .init(color: .red, i: 7.5, j: 7.5)
        case .green: self.trafficLight = .init(color: .green, i: 7.5, j: 7.5)
        }
        super.init(i: i, j: j)
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
        TrafficLightCell(i: 8, j: 10, trafficLight: .yellow)
    }
}

struct TrafficLight: Equatable, Hashable {
    let color: Color
    let i: Double
    let j: Double
}
