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

    var tileImage: Image {
        switch tile.type {
        case .asphalt: return ImageAsset.asphalt.image
        case .curve: return ImageAsset.curve.image
        case .straight: return ImageAsset.straight.image
        case .threeWay: return ImageAsset.threeWay.image
        }
    }
    
    var body: some View {
        
        
        /*
        VStack {
            Text("i: \(tile.i)")
                .font(.headline)
            Text("j: \(tile.j)")
                .font(.subheadline)
        }*/
        tileImage
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
