//
//  MapGridView.swift
//  JASS 2023 Smart City
//
//  Created by Philipp Zagar on 27.03.23.
//

import Foundation
import SwiftUI

struct MapGridView: View {
    @EnvironmentObject var model: CityModel
    
    private var sortedTiles: [Tile] {
        self.model.tiles.values.sorted { (tile1, tile2) -> Bool in
            if tile1.j == tile2.j {
                return tile1.i < tile2.i
            } else {
                return tile1.j > tile2.j
            }
        }
        .filter { tile in
            tile.i < 14
        }
        .filter { tile in
            tile.j > 4
        }
    }
    
    var rowsTiles: Int {
        let rows = self.sortedTiles.reduce(into: 0) { partialResult, element in
            if(partialResult < element.i) {
                partialResult = element.i
            }
        }
        return rows + 1;
    }
    
    var columnsTiles: Int {
        let columns = self.sortedTiles.reduce(into: 0) { partialResult, element in
            if(partialResult < element.j) {
                partialResult = element.j
            }
        }
        return columns + 1;
    }
    
    private var columns: [GridItem] {
        Array(repeating: GridItem(.flexible(), spacing: 0), count: self.rowsTiles)
    }
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 0) {
                ForEach(sortedTiles, id: \.self) { tile in
                    TileCellView(tile: tile)
                }
            }
            .background(Color.black)
            .padding()
        }
    }
}

