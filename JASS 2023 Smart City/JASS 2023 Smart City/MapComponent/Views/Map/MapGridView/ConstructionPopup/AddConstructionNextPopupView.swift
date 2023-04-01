//
//  AddConstructionNextPopupView.swift
//  JASS 2023 Smart City
//
//  Created by Philipp Zagar on 30.03.23.
//

import Foundation
import SwiftUI

struct AddConstructionNextPopupView: View {
    @EnvironmentObject var model: CityModel
    
    @Binding var showPopup: Bool
    let selectedCell: LayeredMapCell?
    
    var cellStates: [[Bool]]
    
    var mappedCellStates: [Quadrant] {
        var quadrants: [Quadrant] = []
        
        if cellStates[0][0] {
            quadrants.append(.upperLeft)
        }
        if cellStates[0][1] {
            quadrants.append(.upperRight)
        }
        if cellStates[1][0] {
            quadrants.append(.lowerLeft)
        }
        if cellStates[1][1] {
            quadrants.append(.lowerRight)
        }
        
        return quadrants
    }
    
    let numbers = Array(1...10)
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var maximumSpeed: Int = 0
    
    var body: some View {
        if let selectedCell {
            VStack {
                Text("Add Construction to i: \((selectedCell.tileCell) .i), j: \(selectedCell.tileCell.j)")
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
                    Task {
                        let id = Int.random(in: 1...1000)
                        let start = self.startDate
                    
                        if self.endDate <= startDate {
                            self.endDate = startDate.addingTimeInterval(10)
                        }
                        let end = self.endDate

                        // publish planning message
                        await self.model.mqtt?.publish(
                            topic: .planConstructionSite,
                            data: PlanConstructionSite.PlanConstructionSite(
                                type: "plan_construction_site",
                                data: .init(
                                    id: .init(),
                                    coordinates: [
                                        .init(x: selectedCell.tileCell.i, y: selectedCell.tileCell.j,
                                              quadrants: self.mappedCellStates,
                                              x_abs: Double(selectedCell.tileCell.i), y_abs: Double(selectedCell.tileCell.j)
                                             )
                                    ],
                                    startDateTime: start,
                                    endDateTime: end,
                                    maximumSpeed: Double(self.maximumSpeed),
                                    trafficLights: .init(id1: .init(), id2: .init())
                                )
                            ),
                            id: id
                        )
                        
                        let layer: ConstructionLayer = CityModel.shared.map.getLayer()
                        
                        let delayStart = Int(max(start.timeIntervalSinceNow, 0))
                        let dispatchStartTime = DispatchTime.now() + .seconds(delayStart)
                        
                        let delayEnd = Int(max(end.timeIntervalSinceNow, 0))
                        var dispatchEndTime = DispatchTime.now() + .seconds(delayEnd)
                        if dispatchEndTime <= dispatchStartTime {
                            dispatchEndTime = dispatchEndTime + .seconds(10)
                        }
                        
                        // publishes built construction site message
                        DispatchQueue.main.asyncAfter(deadline: dispatchStartTime) {
                            Task.detached {
                                let constructionSiteAdd = await StatusConstructionSite.ConstructionSite(message: StatusConstructionSite.MessageString.builtConstructionSite.rawValue, id: id, timestamp: Date.now.formatted(),     coordinates: [
                                    .init(x: selectedCell.tileCell.i, y: selectedCell.tileCell.j,
                                          quadrants: self.mappedCellStates,
                                          x_abs: Double(selectedCell.tileCell.i), y_abs: Double(selectedCell.tileCell.j)
                                         )
                                ], constructionSiteTime: StatusConstructionSite.ConstructionTime(start: start, end: end)
                                                                                                        
                                )
                                
                                // publishes built construction site message
                                await self.model.mqtt?.publish(
                                    topic: .statusConstructionSite,
                                    data:
                                        StatusConstructionSite.StatusConstructionSite(type: "status_construction_site", data:
                                                                                        constructionSiteAdd),
                                    id: id
                                )
                                
                                // backup: if I did not fix the decode ;(
                                
                                layer.update(constructionSiteStatus: StatusConstructionSite.StatusConstructionSite(type: StatusConstructionSite.MessageString.builtConstructionSite.rawValue, data:
                                                                                                                    constructionSiteAdd))
                                await CityModel.shared.trigger()
                            }
                        }
                        
                        
                        // publishes remove construction site message
                        DispatchQueue.main.asyncAfter(deadline: dispatchEndTime) {
                            Task.detached {
                                let constructionSiteRemoved = await StatusConstructionSite.ConstructionSite(message: StatusConstructionSite.MessageString.removeConstructionSite.rawValue, id: id, timestamp: Date.now.formatted(),     coordinates: [
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
                                
                            }
                        }
                        
                        
                        // Perform your action here
                        showPopup = false
                        // Schedule removal
                        // Do status removed
                        
                    }}) {
                        Text("Schedule the construction")
                            .font(.headline)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
            }
            .navigationTitle("Set Details")
            .padding()
        }
    }
}
