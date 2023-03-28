//
//  TileCellView.swift
//  JASS 2023 Smart City
//
//  Created by Philipp Zagar on 27.03.23.
//

import Foundation
import SwiftUI

struct TileCellView: View {
    let cell: LayeredMapCell
    
    var body: some View {
        ZStack {
            cell.tileCell.image
                .resizable()
                .rotationEffect(Angle(degrees: cell.tileCell.yaw ?? 0), anchor: .center)
                .aspectRatio(contentMode: .fit)
                //.frame(width: 60, height: 60)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                //.background(Color.blue.opacity(0.2))
                //.cornerRadius(8)
                //.padding(4)
            
            if let constructionCell = cell.constructionCell {
                constructionCell.image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            
            if let duckieCell = cell.duckieCell {
                duckieCell.image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
}
