//
//  ConstructionSiteStatus.swift
//  JASS 2023 Smart City
//
//  Created by sunny wang on 2023/3/29.
//

import Foundation

enum ConstructionSiteStatus {
    // MARK: - ConstructionSiteStatus
    struct ConstructionSiteStatus: Codable {
        let type: String
        let data: ConstructionSite
    }
    
    // MARK: - ConstructionSite
    struct ConstructionSite: Codable {
        let message: String
        let id: UUID
        let timestamp: String
        let coordinates: [Coordinate]
    }
    
    // MARK: - Coordinate
    struct Coordinate: Codable {
        let x, y: Double
        let x_abs, y_abs: Double
    }
    
    enum MessageString: String {
        case builtConstructionSite = "built_construction_site"
        case removeConstructionSite = "removed_construction_site"
    }
}
