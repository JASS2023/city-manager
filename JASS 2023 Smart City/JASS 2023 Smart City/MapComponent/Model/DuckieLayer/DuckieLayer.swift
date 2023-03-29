//
//  DuckieLayer.swift
//  JASS 2023 Smart City
//
//  Created by Philipp Zagar on 27.03.23.
//

import Foundation

class DuckieLayer: Layer {
    typealias CellType = DuckieCell
    
    static let name = "duckie layer"
    
    init(data: [CellType], overrideLowerLayers: Bool = false) {
        super.init(data: data, name: Self.name, overrideLowerLayers: overrideLowerLayers)
    }
    
    func update(vehicleStatus: VehicleStatus.VehicleStatus) {
        guard var data = self.data as? [DuckieCell] else {
            return
        }
        
        // Find cell that contains the duckie via id
        if let indexCell = data.firstIndex(where: { $0.duckies.contains { duckie in
            duckie.id == vehicleStatus.data.id
        }}) {
            let duckieCell = data[indexCell]
            
            // Duckie is still in the same cell
            if duckieCell.i == Int(vehicleStatus.data.coordinates.x) && duckieCell.j == Int(vehicleStatus.data.coordinates.y) {
                
                // Update the exact coordinates
                if let indexDuckie = duckieCell.duckies.firstIndex(where: { duckie in
                    duckie.id == vehicleStatus.data.id
                }) {
                    data[indexCell].duckies[indexDuckie].i = vehicleStatus.data.coordinates.x
                    data[indexCell].duckies[indexDuckie].j = vehicleStatus.data.coordinates.y
                }
                // Duckie is not in the same cell anymore
            } else {
                // Remove Duckie of old cell
                data[indexCell].duckies.removeAll { duckie in
                    duckie.id == vehicleStatus.data.id
                }
                
                // If Cell is now empty (so no Duckies in there)
                if data[indexCell].duckies.isEmpty {
                    data.remove(at: indexCell)
                }
                
                // Check if a cell with a duckie already exists
                let alreadyExistingCellIndex = data.firstIndex(where: { cell in
                    cell.i == Int(vehicleStatus.data.coordinates.x) && cell.j == Int(vehicleStatus.data.coordinates.y)
                })
                
                if let alreadyExistingCellIndex {
                    // Add duckie to already existing cell
                    data[alreadyExistingCellIndex].duckies.append(
                        .init(
                            id: vehicleStatus.data.id,
                            i: vehicleStatus.data.coordinates.x,
                            j: vehicleStatus.data.coordinates.y,
                            yaw: vehicleStatus.data.coordinates.yaw
                        )
                    )
                } else {
                    // Insert new cell with duckie
                    data.append(
                        .init(
                            i: Int(vehicleStatus.data.coordinates.x),
                            j: Int(vehicleStatus.data.coordinates.y),
                            duckies: [
                                .init(
                                    id: vehicleStatus.data.id,
                                    i: vehicleStatus.data.coordinates.x,
                                    j: vehicleStatus.data.coordinates.y,
                                    yaw: vehicleStatus.data.coordinates.yaw
                                )
                            ]
                        )
                    )
                }
            }
        } else {
            // Check if a cell with a duckie already exists
            let alreadyExistingCellIndex = data.firstIndex(where: { cell in
                cell.i == Int(vehicleStatus.data.coordinates.x) && cell.j == Int(vehicleStatus.data.coordinates.y)
            })
            
            if let alreadyExistingCellIndex {
                // Add duckie to already existing cell
                data[alreadyExistingCellIndex].duckies.append(
                    .init(
                        id: vehicleStatus.data.id,
                        i: vehicleStatus.data.coordinates.x,
                        j: vehicleStatus.data.coordinates.y,
                        yaw: vehicleStatus.data.coordinates.yaw
                    )
                )
            } else {
                // Insert new cell with duckie
                data.append(
                    .init(
                        i: Int(vehicleStatus.data.coordinates.x),
                        j: Int(vehicleStatus.data.coordinates.y),
                        duckies: [
                            .init(
                                id: vehicleStatus.data.id,
                                i: vehicleStatus.data.coordinates.x,
                                j: vehicleStatus.data.coordinates.y,
                                yaw: vehicleStatus.data.coordinates.yaw
                            )
                        ]
                    )
                )
            }
        }
        
        self.data = data
        
        /*
         
         guard let oldDuckieCell: DuckieCell = self.data.removeAll(where: { cell in
         vehicleStatus.data.coordinates.x == cell.i &&
         vehicleStatus.data.coordinates.y == cell.j
         }) as? DuckieCell else {
         return
         }
         
         
         
         let newDuckieCell: DuckieCell = .init(
         i: vehicleStatus.data.coordinates.x,
         j: vehicleStatus.data.coordinates.y,
         duckieUUIDs: [vehicleStatus.data.id] + oldDuckieCell.duckieUUIDs.filter({ uuid in
         uuid
         })
         )
         
         self.data.append(Duck)
         */
    }
}
