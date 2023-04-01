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
    /*
    
    func scheduleRemoval(id: Int, statusService: StatusConstructionSite.StatusConstructionSite) async {
        guard let data = self.data as? [ConstructionCell] else {
            return
        }
        
        
        
        Task {
            await CityModel.shared.mqtt.publish(
                topic: .statusService,
                data: StatusConstructionSite.StatusConstructionSite(
                    type: .status,
                    data: .init(
                        message: StatusConstructionSite.MessageString.removeConstructionSite,
                        id: statusService.data.id,
                        timestamp: statusService.data.timestamp,
                        coordinates: statusService.data.coordinates,
                        constructionSiteTime: statusService.data.constructionSiteTime
                    )
                )
            )
            
            
            let constructionSiteRemoved = StatusConstructionSite.ConstructionSite(message: StatusConstructionSite.MessageString.removeConstructionSite.rawValue, id: id, timestamp: Date.now.formatted(),     coordinates: [
                .init(x: selectedCell.tileCell.i, y: selectedCell.tileCell.j,
                      quadrants: self.mappedCellStates,
                      x_abs: Double(selectedCell.tileCell.i), y_abs: Double(selectedCell.tileCell.j)
                     )
            ], constructionSiteTime: StatusConstructionSite.ConstructionTime(start: start, end: end)
                                                                                  
            )
            // Publish remove messages
            await self.model.mqtt?.publish(
                topic: .statusConstructionSite,
                data:
                    StatusConstructionSite.StatusConstructionSite(
                        type: "status_construction_site",
                        data: constructionSiteRemoved
                    )
                ,id: id
            )
            
            
            
            
            // Publish removed task
            await CityModel.shared.mqtt?.publish(
                topic: .statusService,
                data: StatusService.StatusService(
                    type: .status,
                    data: .init(
                        message: .removed,
                        serviceId: statusService.data.serviceId,
                        timestamp: .now,
                        coordinates: statusService.data.coordinates,
                        timeConstraints: statusService.data.timeConstraints,
                        maximumSpeed: statusService.data.maximumSpeed
                    )
                ),
                id: id
            )
        }
        
        data.forEach { cell in
            // Calculate the time interval between the current date and the desired date
            let timeInterval = cell.timeConstraints.end.timeIntervalSinceNow

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
    
    func scheduleRemoval(id: Int, statusService: StatusConstructionSite.StatusConstructionSite) async {
        guard let data = self.data as? [ConstructionCell] else {
            return
        }
        
        // publishes remove construction site message
        DispatchQueue.main.asyncAfter(deadline: dispatchEndTime) {
            Task {
                let constructionSiteRemoved = StatusConstructionSite.ConstructionSite(message: StatusConstructionSite.MessageString.removeConstructionSite.rawValue, id: id, timestamp: Date.now.formatted(),     coordinates: [
                    .init(x: selectedCell.tileCell.i, y: selectedCell.tileCell.j,
                          quadrants: self.mappedCellStates,
                          x_abs: Double(selectedCell.tileCell.i), y_abs: Double(selectedCell.tileCell.j)
                         )
                ], constructionSiteTime: StatusConstructionSite.ConstructionTime(start: start, end: end)
                                                                                      
                )
                // Publish remove messages
                await self.model.mqtt?.publish(
                    topic: .statusConstructionSite,
                    data:
                        StatusConstructionSite.StatusConstructionSite(type: "status_construction_site", data:
                                                                        constructionSiteRemoved
                                                                     )
                    ,id: id
                )
                guard let data = layer.data as? [ConstructionCell] else {
                    return
                }
                data.forEach { cell in
                    layer.data.removeAll { cell in
                        if let cell = cell as? ConstructionCell {
                            if cell.constructionTime.end < .now {
                                return true
                            }
                        }
                        return false;
                    }
                }
                CityModel.shared.trigger()
            }
        }
        
        Task {
            // Publish removed task
            await CityModel.shared.mqtt?.publish(
                topic: .statusService,
                data: StatusService.StatusService(
                    type: .status,
                    data: .init(
                        message: .removed,
                        serviceId: statusService.data.serviceId,
                        timestamp: .now,
                        coordinates: statusService.data.coordinates,
                        timeConstraints: statusService.data.timeConstraints,
                        maximumSpeed: statusService.data.maximumSpeed
                    )
                ),
                id: id
            )
        }
        
        data.forEach { cell in
            // Calculate the time interval between the current date and the desired date
            let timeInterval = cell.timeConstraints.end.timeIntervalSinceNow

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
     */
}
