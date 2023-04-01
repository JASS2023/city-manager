//
//  AddServicePopupView.swift
//  JASS 2023 Smart City
//
//  Created by Philipp Zagar on 30.03.23.
//

import Foundation
import SwiftUI

struct AddServicePopupView: View {
    @EnvironmentObject var model: CityModel
    
    @Namespace private var animation
    @State private var showNextView = false
    @Binding var showPopup: Bool
    let selectedCell: LayeredMapCell?
    
    let numbers = Array(1...10)
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var maximumSpeed: Int = 0
    
    var adjecentRoadTiles: [PlanService.Coordinate] {
        let tileLayer: TileLayer = self.model.map.getLayer()
        return Array(Set(tileLayer.data.compactMap { cell in
            if let tileCell = cell as? TileCell,
               let selectedCell,
               tileCell.type != .asphalt {
                let diffI = abs(tileCell.i - selectedCell.tileCell.i)
                let diffJ = abs(tileCell.j - selectedCell.tileCell.j)
                if (diffI == 1 && diffJ == 0) || (diffI == 0 && diffJ == 1) || (diffI == 1 && diffJ == 1) {
                    return .init(x: tileCell.i, y: tileCell.j, quadrant: .none)
                }
            }
            
            return nil
        }))
    }
    
    var body: some View {
        if let selectedCell {
            VStack {
                Text("Add Service to i: \((selectedCell.tileCell) .i), j: \(selectedCell.tileCell.j)")
                    .font(.title)
                
                DatePicker("Start Time", selection: $startDate, displayedComponents: .hourAndMinute)
                    .padding()
                
                DatePicker("End Time", selection: $endDate, displayedComponents: .hourAndMinute)
                    .padding()
                
                HStack {
                    Text("Selecte Maximum Speed (in cm/s):")
                        .padding()
                    
                    Spacer()
                    
                    Picker("Select a Number", selection: $maximumSpeed) {
                        ForEach(numbers, id: \.self) { number in
                            Text("\(number)")
                        }
                    }
                    .pickerStyle(.automatic)
                    .frame(width: 150, height: 50)
                }
                
                Button(action: {
                    let id: Int = .random(in: 1..<1000)
                    let uuid: UUID = .init()
                    
                    let start = self.startDate
                
                    if self.endDate <= startDate {
                        self.endDate = startDate.addingTimeInterval(10)
                    }
                    let end = self.endDate
                    
                    Task {
                        // Publish planning task
                        await self.model.mqtt?.publish(
                            topic: .planService,
                            data: PlanService.PlanService(
                                type: .plan,
                                data: .init(
                                    message: .planned,
                                    serviceId: uuid,
                                    timestamp: .now,
                                    coordinates: self.adjecentRoadTiles,
                                    timeConstraints: .init(
                                        start: start,
                                        end: end
                                    ),
                                    maximumSpeed: Double(self.maximumSpeed))
                            ),
                            id: id
                        )
                        
                        
                    }
                    let serviceLayer: ServiceLayer = self.model.map.getLayer()
                    
                    let statusService = StatusService.StatusService(
                        type: .status,
                        data: .init(
                            message: .built,
                            serviceId: uuid,
                            timestamp: .now,
                            coordinates: self.adjecentRoadTiles.map({ coordinate in
                                    .init(x: coordinate.x, y: coordinate.y, quadrant: coordinate.quadrant)
                            }),
                            timeConstraints: .init(
                                start: start,
                                end: end
                            ),
                            maximumSpeed: Double(self.maximumSpeed)
                        )
                    )
                    
                    let delayStart = Int(max(start.timeIntervalSinceNow, 0))
                    let dispatchStartTime = DispatchTime.now() + .seconds(delayStart)
                    
                    let delayEnd = Int(max(end.timeIntervalSinceNow, 0))
                    let dispatchEndTime = DispatchTime.now() + .seconds(delayEnd)
                    
                    // service constraints starts
                    DispatchQueue.main.asyncAfter(deadline: dispatchStartTime) {
                        Task.detached {
                            // Publish built service constraints
                            await self.model.mqtt?.publish(
                                topic: .statusService,
                                data: statusService,
                                id: id
                            )
                            
                            // Update service view during constraints
                            await self.adjecentRoadTiles.forEach { coordinate in
                                serviceLayer.addNewCell(
                                    cell: ServiceCell(
                                        i: coordinate.x,
                                        j: coordinate.y,
                                        constraintType: .school(.orange),
                                        maximumSpeed: 3.0,
                                        timeConstraints: .init(
                                            start: statusService.data.timeConstraints.start,
                                            end: statusService.data.timeConstraints.end)
                                    )
                                )
                            }
                            
                        }
                    }
                    
                    // service constraints ends
                    DispatchQueue.main.asyncAfter(deadline: dispatchEndTime) {
                        Task.detached {
                            // Publish remove service constraints
                            await serviceLayer.scheduleRemoval(id: id, statusService: statusService)
                        }
                    }
                    
                    
                    self.model.trigger()
                    
                    // Perform your action here
                    showPopup = false
                }) {
                    Text("Schedule the service")
                        .font(.headline)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
        }
    }
}
