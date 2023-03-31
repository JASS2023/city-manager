//
//  DetailsCellView.swift
//  JASS 2023 Smart City
//
//  Created by Philipp Zagar on 31.03.23.
//

import Foundation
import SwiftUI

struct DetailsCellView: View {
    @EnvironmentObject var model: CityModel
    
    //@Binding var showPopup: Bool
    let constructionCell: ConstructionCell?
    let serviceCell: ServiceCell?
    
    var body: some View {
        VStack {
            // TODO: Display appropiate data
            if let constructionCell {
                Text("ConstructionCell")
                    .font(.title)
                
                HStack {
                    Text("Max. Speed (cm/s)")
                    
                    Spacer()
                    
                    //Text(constructionCell.)
                }
            }
            
            if let serviceCell {
                Text("ServiceCell constraints")
                    .font(.title)
                
                HStack {
                    Text("Max. Speed (cm/s)")
                    
                    Spacer()
                    
                    Text(serviceCell.maximumSpeed.description)
                }.padding()
                
                HStack {
                    Text("End date")
                    
                    Spacer()
                    
                    Text(serviceCell.timeConstraints.end.formatted(date: .omitted, time: .standard))
                }.padding()
            }
        }
    }
}
