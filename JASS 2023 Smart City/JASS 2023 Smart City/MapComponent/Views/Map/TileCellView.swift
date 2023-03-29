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
        ZStack(alignment: .topLeading) {
            cell.tileCell.image
                .resizable()
                .rotationEffect(Angle(degrees: cell.tileCell.yaw ?? 0), anchor: .center)
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            if let constructionCell = cell.constructionCell {
                constructionCell.image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .background(Color(UIColor.red.withAlphaComponent(0.8)))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            
            if let duckieCell = cell.duckieCell {
                ForEach(duckieCell.duckies) { ducky in
                    duckieCell.image
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding(.top, ducky.i.truncatingRemainder(dividingBy: 1) * 50)
                        .padding(.leading, ducky.j.truncatingRemainder(dividingBy: 1) * 50)
                }
                /*
                duckieCell.image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    //.frame(maxWidth: .infinity, maxHeight: .infinity)
                    .frame(width: geometry.size.width * 0.25)
                    .position(x: geometry.size.width * , y: geometry.size.height * percentageY)
                 */
            }
        }
    }
}
