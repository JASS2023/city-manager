//
//  ConstructionLayer.swift
//  JASS 2023 Smart City
//
//  Created by sunny wang on 2023/3/28.
//

import Foundation
class ConstructionLayer: Layer {
    typealias CellType = ConstructionCell
    static let name = "construction layer"
    
    init(data: [CellType], overrideLowerLayers: Bool = false) {
        super.init(data: data, name: Self.name, overrideLowerLayers: overrideLowerLayers)
    }
    
    func update(constructionSiteStatus: StatusConstructionSite.StatusConstructionSite) {
        guard var data = self.data as? [ConstructionCell] else {
            return
        }
        
        switch constructionSiteStatus.data.message {
        case StatusConstructionSite.MessageString.builtConstructionSite.rawValue:
            print("🚧built!")
            constructionSiteStatus.data.coordinates.forEach { coordinate in
                data.append(.init(i: Int(coordinate.x), j: Int(coordinate.y), constructionSiteUUID: constructionSiteStatus.data.id, quadrants: coordinate.quadrants))
            }
        case StatusConstructionSite.MessageString.removeConstructionSite.rawValue:
            print("❌removed!")
            data.removeAll { cell in
                cell.constructionSiteUUID == constructionSiteStatus.data.id
            }
        default:
            break
        }
        
        self.data = data
    }
}
