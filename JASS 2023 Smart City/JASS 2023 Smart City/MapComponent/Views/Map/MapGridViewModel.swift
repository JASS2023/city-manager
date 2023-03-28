//
//  MapGridViewModel.swift
//  JASS 2023 Smart City
//
//  Created by Philipp Zagar on 27.03.23.
//

import Foundation
import SwiftUI

protocol MapGridViewModelProtocol: ObservableObject {
    
}

@MainActor
class MapGridViewModel: MapGridViewModelProtocol {
    @Published var model: CityModel
    
    init(model: CityModel) {
        self.model = model
    }
    
    var cells: [LayeredMapCell] {
        self.sortedTiles
            .map { tilecell in
                let duckieCell = self.model.duckieCells.first { duckieCell in
                    duckieCell.i == tilecell.i && duckieCell.j == tilecell.j
                }
                
                return .init(tileCell: tilecell, duckieCell: duckieCell)
            }
    }
    
    private var sortedCells: [(TileCell, DuckieCell?)] {
        self.sortedTiles
            .map { tilecell in
                let duckieCell = self.model.duckieCells.first { duckieCell in
                    duckieCell.i == tilecell.i && duckieCell.j == tilecell.j
                }
                
                return (tilecell, duckieCell)
            }
    }
    
    private var sortedTiles: [TileCell] {
        self.model.tileCells.sorted { (tile1, tile2) -> Bool in
            // Sort tiles according to the global coordinate system
            if tile1.j == tile2.j {
                return tile1.i < tile2.i
            } else {
                return tile1.j > tile2.j
            }
        }
        // Crops the irrelevant tiles
        .filter { tile in
            tile.i < 14
        }
        .filter { tile in
            tile.j > 4
        }
    }
    
    var columns: [GridItem] {
        Array(repeating: GridItem(.flexible(), spacing: 0), count: self.rowsTiles)
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
}

