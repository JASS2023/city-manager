//
//  ObstacleMapView.swift
//  JASS 2023 Smart City
//
//  Created by Philipp Zagar on 01.04.23.
//

import Foundation
import SwiftUI

struct ObstacleMapView: View {
    var subviewSize: CGSize
    var isSubroomView: Bool
    @EnvironmentObject var model: CityModel
    
    var body: some View {
        ForEach(self.model.obstacleCells) { obstacleCell in
            ForEach(obstacleCell.obstacles) { obstacle in
                obstacleCell.image
                    .resizable()
                    .scaledToFit()
                    .rotationEffect(Angle(degrees: obstacle.yaw), anchor: .center)
                    .frame(width: 50, height: 50)
                    .position(getPosition(for: self.subviewSize, obstacle: obstacle))
            }
        }
    }
    
    func getPosition(for size: CGSize, obstacle: Obstacle) -> CGPoint {
        if isSubroomView {
            let widthCell = size.width / 6
            let heightCell = size.height / 6
            
            return CGPoint(x: ((-obstacle.i + 6) * widthCell), y: ((-obstacle.j + 12) * heightCell) - 0) // TODO: fix
        } else {
            let widthCell = size.width / 13.9
            let heightCell = size.height / 15.8
            
            return CGPoint(x: (obstacle.i + 1) * widthCell, y: (obstacle.j + 1) * heightCell)   // TODO: +1 fix
        }
    }
}
