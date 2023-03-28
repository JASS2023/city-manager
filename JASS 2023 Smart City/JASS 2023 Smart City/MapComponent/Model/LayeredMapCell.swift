//
//  LayeredMapCell.swift
//  JASS 2023 Smart City
//
//  Created by Philipp Zagar on 28.03.23.
//

import Foundation

class LayeredMapCell: ObservableObject, Hashable, Equatable {
    @Published var tileCell: TileCell
    @Published var duckieCell: DuckieCell?
    
    init(tileCell: TileCell, duckieCell: DuckieCell?) {
        self.tileCell = tileCell
        self.duckieCell = duckieCell
    }
    
    static func == (lhs: LayeredMapCell, rhs: LayeredMapCell) -> Bool {
        lhs.tileCell == rhs.tileCell && lhs.duckieCell == rhs.duckieCell
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(tileCell)
        hasher.combine(duckieCell)
    }
}
