//
//  DuckieMapView.swift
//  JASS 2023 Smart City
//
//  Created by Philipp Zagar on 29.03.23.
//

import Foundation
import SwiftUI

struct DuckieMapView: View {
    var subviewSize: CGSize
    @ObservedObject var vm = DuckieMapViewModel.shared
    
    var body: some View {
        ForEach(self.vm.duckieCells) { duckieCell in
            ForEach(duckieCell.duckies) { duckie in
                TileType.duckie.image
                    .resizable()
                    .scaledToFit()
                    .rotationEffect(Angle(degrees: duckie.yaw), anchor: .center)
                    .frame(width: 25, height: 25)
                    .position(getPosition(for: self.subviewSize, cell: duckie))
            }
        }
    }
    
    func getPosition(for size: CGSize, cell: Duckie) -> CGPoint {
        let widthCell = size.width / 13.9
        let heightCell = size.height / 15.8
        
        return CGPoint(x: (cell.i + 1) * widthCell, y: (cell.j + 1) * heightCell)   // TODO: +1 fix
    }
}

class DuckieMapViewModel: ObservableObject {
    static let shared = DuckieMapViewModel()
    
    @Published var duckieMap: DuckieLayer = .init(data: [])
    var duckieCells: [DuckieCell] {
        self.duckieMap.data as? [DuckieCell] ?? []
    }
    
    private init() {} // Prevent creating other instances
}
