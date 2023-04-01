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
                data.append(.init(i: Int(coordinate.x), j: Int(coordinate.y), constructionSiteUUID: constructionSiteStatus.data.id, quadrants: coordinate.quadrants, constructionTime: constructionSiteStatus.data.constructionSiteTime))
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
    
    func scheduleRemoval(id: Int, statusService: StatusConstructionSite.StatusConstructionSite) async {
        guard let data = self.data as? [ConstructionCell] else {
            return
        }
        
        Task {
            // Publish removed task
            await CityModel.shared.mqtt?.publish(
                topic: .statusConstructionSite,
                data: StatusConstructionSite.StatusConstructionSite(type: StatusConstructionSite.MessageString.builtConstructionSite.rawValue, data: StatusConstructionSite.ConstructionSite(message: "", id: UUID(), timestamp: "String", coordinates: [StatusConstructionSite.Coordinate(x: 8, y: 8, quadrants: [.none], x_abs: 0.0, y_abs: 0.0)], constructionSiteTime: .init(start: .now, end: .now.advanced(by: 10)))),
                id: id
            )
        }
        
        data.forEach { cell in
            // Calculate the time interval between the current date and the desired date
            let timeInterval = cell.constructionTime.end.timeIntervalSinceNow

            // Make sure the time interval is positive (i.e., in the future)
            guard timeInterval > 0 else {
                print("The desired date is in the past, remove it still")
                
                self.data.removeAll { cell in
                    if let cell = cell as? ServiceCell {
                        if cell.timeConstraints.end < .now {
                            return true
                        }
                    }
                    return false;
                }
                
                return
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + timeInterval) {
                self.data.removeAll { cell in
                    if let cell = cell as? ServiceCell {
                        if cell.timeConstraints.end < .now {
                            return true
                        }
                    }
                    return false;
                }
                
                CityModel.shared.trigger()
            }
        }
    }
    
    
    func scheduleAdd(id: Int, statusService: StatusConstructionSite.StatusConstructionSite) async {
        guard let data = self.data as? [ConstructionCell] else {
            return
        }
        
        Task {
            // Publish removed task
            await CityModel.shared.mqtt?.publish(
                topic: .statusConstructionSite,
                data: StatusConstructionSite.StatusConstructionSite(type: StatusConstructionSite.MessageString.builtConstructionSite.rawValue, data: StatusConstructionSite.ConstructionSite(message: StatusConstructionSite.MessageString.builtConstructionSite.rawValue, id: UUID(), timestamp: Date.now.formatted(), coordinates: [StatusConstructionSite.Coordinate(x: 8, y: 8, quadrants: [.none], x_abs: 0.0, y_abs: 0.0)], constructionSiteTime: .init(start: .now, end: .now.advanced(by: 10)))),
                id: id
            )
        }
        
        data.forEach { cell in
            // Calculate the time interval between the current date and the desired date
            let timeInterval = cell.constructionTime.end.timeIntervalSinceNow

            // Make sure the time interval is positive (i.e., in the future)
            guard timeInterval > 0 else {
                print("The desired date is in the past, remove it still")
                
                self.data.removeAll { cell in
                    if let cell = cell as? ServiceCell {
                        if cell.timeConstraints.end < .now {
                            return true
                        }
                    }
                    return false;
                }
                
                return
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + timeInterval) {
                self.data.removeAll { cell in
                    if let cell = cell as? ServiceCell {
                        if cell.timeConstraints.end < .now {
                            return true
                        }
                    }
                    return false;
                }
                
                CityModel.shared.trigger()
            }
        }
    }
}
