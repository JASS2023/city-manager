//
//  ServiceLayer.swift
//  JASS 2023 Smart City
//
//  Created by Philipp Zagar on 30.03.23.
//

import Foundation

class ServiceLayer: Layer {
    typealias CellType = ServiceCell
    static let name = "service layer"
    
    init(data: [CellType], overrideLowerLayers: Bool = false) {
        super.init(data: data, name: Self.name, overrideLowerLayers: overrideLowerLayers)
    }
    
    func scheduleRemoval(id: Int, statusService: StatusService.StatusService) async {
        guard let data = self.data as? [ServiceCell] else {
            return
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
}
