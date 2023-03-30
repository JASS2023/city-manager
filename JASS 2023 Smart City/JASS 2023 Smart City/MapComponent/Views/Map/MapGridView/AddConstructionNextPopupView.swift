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
                Text("Road i: \((selectedCell.tileCell) .i), j: \(selectedCell.tileCell.j)")
                    .font(.title)
                
                DatePicker("Start Time", selection: $startDate, displayedComponents: .hourAndMinute)
                    .padding()

                DatePicker("End Time", selection: $endDate, displayedComponents: .hourAndMinute)
                    .padding()

                HStack {
                    Text("Selecte Maximum Speed:")
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
                                    startDateTime: self.startDate,
                                    endDateTime: self.endDate,
                                    maximumSpeed: Double(self.maximumSpeed),
                                    trafficLights: .init(id1: .init(), id2: .init())
                                )
                            ),
                            id: 12
                        )
                    }
                    
                    // Perform your action here
                    showPopup = false
                }) {
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
