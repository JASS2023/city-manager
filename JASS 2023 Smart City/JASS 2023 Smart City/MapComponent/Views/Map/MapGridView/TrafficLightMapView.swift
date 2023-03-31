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
    @EnvironmentObject var model: CityModel
    
    var body: some View {
        ForEach(self.model.trafficCells) { trafficCell in
            Circle()
                .frame(width: 40, height: 40)
                .foregroundColor(trafficCell.trafficLight.color)
                .position(getPosition(for: self.subviewSize, trafflicLight: trafficCell.trafficLight))
        }
    }
    
    func getPosition(for size: CGSize, trafflicLight: TrafficLight) -> CGPoint {
        let widthCell = size.width / 6
        let heightCell = size.height / 6
        
        return CGPoint(x: ((-trafflicLight.i + 6) * widthCell + 30), y: ((-trafflicLight.j + 12) * heightCell) - 0) // TODO: fix
    }
}
