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
    let angle: Double
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            cell.tileCell.image
                .resizable()
                .rotationEffect(Angle(degrees: (cell.tileCell.yaw ?? 0) + self.angle), anchor: .center)
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            GeometryReader { geometry in
                let cellWidth = geometry.size.width / 2
                let cellHeight = geometry.size.height / 2
                
                ForEach(cell.constructionCell?.quadrants ?? []) { quadrant in
                    VStack(spacing: 0) {
                        ForEach(0..<2) { row in
                            HStack(spacing: 0) {
                                ForEach(0..<2) { column in
                                    Group {
                                        if quadrant.coordinates == (column, row) {
                                            cell.constructionCell?.image
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: cellWidth * 0.8, height: cellHeight * 0.8)
                                        } else {
                                            Spacer()
                                        }
                                    }
                                    .frame(width: cellWidth, height: cellHeight)
                                }
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
            }
        }
    }
}