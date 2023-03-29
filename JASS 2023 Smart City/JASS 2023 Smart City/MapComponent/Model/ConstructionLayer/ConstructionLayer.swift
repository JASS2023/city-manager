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
    
    func update(constructionSiteStatus: ConstructionSiteStatus.ConstructionSiteStatus) {
        guard var data = self.data as? [ConstructionCell] else {
            return
        }
        
        switch constructionSiteStatus.data.message {
        case ConstructionSiteStatus.MessageString.builtConstructionSite.rawValue:
            print("🚧built!")
            constructionSiteStatus.data.coordinates.forEach { coordinate in
                data.append(.init(i: Int(coordinate.x), j: Int(coordinate.y), constructionSiteUUIDs: [constructionSiteStatus.data.id]))
            }
        case ConstructionSiteStatus.MessageString.removeConstructionSite.rawValue:
            print("❌removed!")
            if let indexCell = data.firstIndex(where: { $0.constructionSiteUUIDs.contains { constructionSiteId in
                constructionSiteId == constructionSiteStatus.data.id
            }}) {
                data[indexCell].constructionSiteUUIDs.removeAll { constructionUuid in
                    constructionUuid == constructionSiteStatus.data.id
                }
            }
        default:
            break
        }
        self.data = data
    }
}
