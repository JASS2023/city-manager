//
//  TileCellView.swift
//  JASS 2023 Smart City
//
//  Created by Philipp Zagar on 27.03.23.
//

import Foundation
import SwiftUI

struct TileCellView: View {
    let tile: Tile
    
    var body: some View {
        tile.image
            .resizable()
            .rotationEffect(Angle(degrees: tile.yaw ?? 0), anchor: .center)
            .aspectRatio(contentMode: .fit)
            //.frame(width: 60, height: 60)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            //.background(Color.blue.opacity(0.2))
            //.cornerRadius(8)
            //.padding(4)
    }
}
