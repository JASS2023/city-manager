//
//  AddCellPopupView.swift
//  JASS 2023 Smart City
//
//  Created by Philipp Zagar on 30.03.23.
//

import Foundation
import SwiftUI

struct AddCellPopupView: View {
    @EnvironmentObject var model: CityModel
    
    @Binding var showPopup: Bool
    let selectedCell: LayeredMapCell?
    
    var body: some View {
        if self.showPopup {
            if let selectedCell {
                ZStack(alignment: .topTrailing) {
                    VStack {
                        Spacer()
                        
                        if selectedCell.tileCell.type == .asphalt {
                            AddServicePopupView(selectedCell: selectedCell)
                        } else {
                            AddConstructionPopupView(showPopup: $showPopup, selectedCell: selectedCell)
                        }
                        
                        /*
                        Button(action: {
                            // Perform your action here
                            showPopup = false
                        }) {
                            Text("Do something")
                                .font(.headline)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                         */
                        
                        Spacer()
                    }
                    .frame(width: 500, height: 350)
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(radius: 10)
                    .padding(20)
                    
                    Button(action: {
                        showPopup = false
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.gray)
                    }
                    .padding(4)
                }
            }
        }
    }
}
