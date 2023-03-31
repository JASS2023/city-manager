//
//  DuckiePresentationMapView.swift
//  JASS 2023 Smart City
//
//  Created by Philipp Zagar on 30.03.23.
//

import Foundation
import SwiftUI

struct DuckiePresentationMapView: View {
    var subviewSize: CGSize
    @ObservedObject var vm = DuckiePresentationMapViewModel.shared
    
    var body: some View {
        ForEach(self.vm.duckieCells) { duckieCell in
            ForEach(duckieCell.duckies) { duckie in
                TileType.duckie.image
                    .resizable()
                    .scaledToFit()
                    .rotationEffect(Angle(degrees: duckie.yaw), anchor: .center)
                    .frame(width: 40, height: 40)
                    .position(getPosition(for: self.subviewSize, cell: duckie))
            }
        }
    }
    
    func getPosition(for size: CGSize, cell: Duckie) -> CGPoint {
        let widthCell = size.width / 6
        let heightCell = size.height / 6
        
        /*
        print("Width Geometry: \(size.width)")
        print("Height Geometry: \(size.height)")
        
        print("Width Device: \(UIScreen.main.bounds.width)")
        print("Height Device: \(UIScreen.main.bounds.height)")
        
        print("Received i: \(cell.i)   - Becomes i: \(-cell.i + 6)")
        print("Received j: \(cell.j)   - Becomes j: \(-cell.j + 12)")
         */
        
        //return CGPoint(x: abs(cell.i - 6) * widthCell, y: abs(cell.j - 12) * heightCell)   // TODO: +1 fix
        return CGPoint(x: ((-cell.i + 6) * widthCell), y: ((-cell.j + 12) * heightCell)) // TODO: fix
    }
}

class DuckiePresentationMapViewModel: ObservableObject {
    static let shared = DuckiePresentationMapViewModel()
    
    @Published var duckieMap: DuckieLayer = .init(data: [])
    var duckieCells: [DuckieCell] {
        self.duckieMap.data as? [DuckieCell] ?? []
    }
    
    private init() {} // Prevent creating other instances
}
