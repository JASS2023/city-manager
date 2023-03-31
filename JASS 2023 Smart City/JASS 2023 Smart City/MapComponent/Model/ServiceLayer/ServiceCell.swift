//
//  ServiceCell.swift
//  JASS 2023 Smart City
//
//  Created by Philipp Zagar on 30.03.23.
//

import Foundation
import SwiftUI

class ServiceCell: Cell, Equatable, Hashable, Identifiable {
    var id: UUID = UUID()
    let constraintType: ConstraintType
    let maximumSpeed: Double
    let timeConstraints: PlanService.TimeConstraints
    
    init(i: Int, j: Int, constraintType: ConstraintType, maximumSpeed: Double, timeConstraints: PlanService.TimeConstraints) {
        self.constraintType = constraintType
        self.maximumSpeed = maximumSpeed
        self.timeConstraints = timeConstraints
        super.init(i: i, j: j)
    }
    
    static func == (lhs: ServiceCell, rhs: ServiceCell) -> Bool {
        lhs.i == rhs.i && lhs.j == rhs.j && lhs.id == rhs.id && lhs.constraintType == rhs.constraintType && lhs.maximumSpeed == rhs.maximumSpeed && lhs.timeConstraints == rhs.timeConstraints
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(i)
        hasher.combine(j)
        hasher.combine(id)
        hasher.combine(constraintType)
        hasher.combine(maximumSpeed)
        hasher.combine(timeConstraints)
    }
}

extension ServiceCell {
    public static var defaultTile: ServiceCell {
        ServiceCell(i: 8, j: 10, constraintType: .school(.yellow), maximumSpeed: 10.0, timeConstraints: .init(start: .now, end: .now.advanced(by: 10)))
    }
}

enum ConstraintType: Equatable, Hashable {
    case school(Color)
    case church(Color)
    case hospital(Color)
}
