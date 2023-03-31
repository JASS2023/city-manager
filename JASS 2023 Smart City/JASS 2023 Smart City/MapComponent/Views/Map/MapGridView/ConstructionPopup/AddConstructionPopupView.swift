//
//  AddConstructionPopupView.swift
//  JASS 2023 Smart City
//
//  Created by Philipp Zagar on 30.03.23.
//

import Foundation
import SwiftUI

struct AddConstructionPopupView: View {
    @EnvironmentObject var model: CityModel
    
    @Namespace private var animation
    @State private var showNextView = false
    @Binding var showPopup: Bool
    let selectedCell: LayeredMapCell?
    
    @State private var cellStates: [[Bool]] = Array(repeating: Array(repeating: false, count: 2), count: 2)
    
    var body: some View {
        if let selectedCell {
            if !showNextView {
                if selectedCell.serviceCell != nil || selectedCell.constructionCell != nil {
                    DetailsCellView(constructionCell: selectedCell.constructionCell, serviceCell: selectedCell.serviceCell)
                } else {
                    VStack {
                        Text("Add Construction to i: \((selectedCell.tileCell) .i), j: \(selectedCell.tileCell.j)")
                            .font(.title)
                        
                        ZStack {
                            self.selectedCell?.tileCell.image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .rotationEffect(Angle(degrees: selectedCell.tileCell.yaw ?? 0), anchor: .center)
                                .edgesIgnoringSafeArea(.all)
                            
                            VStack(spacing: 1) {
                                ForEach(0..<2) { row in
                                    HStack(spacing: 1) {
                                        ForEach(0..<2) { column in
                                            Button(action: {
                                                cellStates[row][column].toggle()
                                            }) {
                                                if cellStates[row][column] {
                                                    TileType.cone.image
                                                        .resizable()
                                                        .scaledToFit()
                                                        .foregroundColor(.blue)
                                                } else {
                                                    Color.clear
                                                }
                                            }
                                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                                        }
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .aspectRatio(1, contentMode: .fit)
                            
                            .edgesIgnoringSafeArea(.all)
                        }
                        
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                showNextView = true
                            }
                        }) {
                            Text("Next")
                                .font(.headline)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                }
            } else {
                AddConstructionNextPopupView(showPopup: self.$showPopup, selectedCell: self.selectedCell, cellStates: self.cellStates)
                    .transition(.slide)
                    .animation(.spring())
            }
        }
    }
}
