//
//  StatusConstructionSite.swift
//  JASS 2023 Smart City
//
//  Created by sunny wang on 2023/3/29.
//

import Foundation

enum StatusConstructionSite {
    // MARK: - StatusConstructionSite
    struct StatusConstructionSite: Codable {
        let type: String
        let data: ConstructionSite
    }
    
    // MARK: - ConstructionSite
    struct ConstructionSite: Codable {
        let message: String
        let id: UUID
        let timestamp: String
        let coordinates: [Coordinate]
        let constructionSiteTime: ConstructionTime
    }
    
    // MARK: - Coordinate
    struct Coordinate: Codable {
        let x, y: Int
        let quadrants: [Quadrant]
        let x_abs, y_abs: Double
    }
    
    enum MessageString: String {
        case builtConstructionSite = "built_construction_site"
        case removeConstructionSite = "removed_construction_site"
    }
    
    // MARK: - ConstructionTime
    struct ConstructionTime: Codable, Hashable, Equatable {
        let start, end: Date
    }
}
