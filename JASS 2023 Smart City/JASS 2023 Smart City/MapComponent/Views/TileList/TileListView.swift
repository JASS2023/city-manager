//
//  TileListView.swift
//  JASS 2023 Smart City
//
//  Created by Philipp Zagar on 27.03.23.
//

import Foundation
import SwiftUI

struct TileRowList: View {
    @EnvironmentObject var model: CityModel
    
    var body: some View {
        List {
            ForEach(Array(self.model.tiles.keys), id: \.self) { key in
                TileRowView(key: key, tile: self.model.tiles[key] ?? TileCell.defaultTile)
            }
        }
    }
}
