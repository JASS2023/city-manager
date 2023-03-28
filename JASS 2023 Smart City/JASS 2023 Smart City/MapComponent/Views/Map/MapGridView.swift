//
//  MapGridView.swift
//  JASS 2023 Smart City
//
//  Created by Philipp Zagar on 27.03.23.
//

import Foundation
import SwiftUI

struct MapGridView: View {
    @StateObject private var vm: MapGridViewModel
    
    init(cityModel: CityModel) {
        self._vm = StateObject(wrappedValue: { MapGridViewModel(model: cityModel) }())
    }
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: self.vm.columns, spacing: 0) {
                ForEach(self.vm.cells, id: \.self) { cell in
                    TileCellView(cell: cell)
                }
            }
            .background(Color.black)
            .padding()
        }
    }
}

