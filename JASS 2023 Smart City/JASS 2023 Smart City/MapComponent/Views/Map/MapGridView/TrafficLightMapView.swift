//
//  TrafficLightMapView.swift
//  JASS 2023 Smart City
//
//  Created by Philipp Zagar on 31.03.23.
//

import Foundation
import SwiftUI

struct TrafficLightMapView: View {
    var subviewSize: CGSize
    var isSubroomView: Bool
    @EnvironmentObject var model: CityModel
    
    var body: some View {
        ForEach(self.model.trafficCells) { trafficCell in
            VStack {
                Circle()
                    .fill(Color.red.opacity((trafficCell.trafficLight.color == .red || trafficCell.trafficLight.color == .prepare) ? 1.0 : 0.3))
                    .frame(width: 25, height: 25)

                Circle()
                    .fill(Color.yellow.opacity((trafficCell.trafficLight.color == .yellow || trafficCell.trafficLight.color == .prepare) ? 1.0 : 0.3))
                    .frame(width: 25, height: 25)

                Circle()
                    .fill(Color.green.opacity(trafficCell.trafficLight.color == .green ? 1.0 : 0.3))
                    .frame(width: 25, height: 25)
            }
            .padding(6)
            .background(Color.white)
            .border(Color.white, width: 3)
            .cornerRadius(5)
            .shadow(radius: 5)
            .position(getPosition(for: self.subviewSize, trafflicLight: trafficCell.trafficLight))
        }
    }
    
    func getPosition(for size: CGSize, trafflicLight: TrafficLight) -> CGPoint {
        if isSubroomView {
            let widthCell = size.width / 6
            let heightCell = size.height / 6
            
            return CGPoint(x: ((-trafflicLight.i + 6) * widthCell), y: ((-trafflicLight.j + 12) * heightCell) - 0) // TODO: fix
        } else {
            let widthCell = size.width / 13.9
            let heightCell = size.height / 15.8
            
            return CGPoint(x: (trafflicLight.i + 1) * widthCell, y: (trafflicLight.j + 1) * heightCell)   // TODO: +1 fix
        }
    }
}
