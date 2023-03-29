//
//  LayeredMapCell.swift
//  JASS 2023 Smart City
//
//  Created by Philipp Zagar on 28.03.23.
//

import Foundation

class LayeredMapCell: ObservableObject, Hashable, Equatable {
    @Published var tileCell: TileCell
    @Published var constructionCell: ConstructionCell?
    
    init(tileCell: TileCell, constructionCell: ConstructionCell?) {
        self.tileCell = tileCell
        self.constructionCell = constructionCell
    }
    
    static func == (lhs: LayeredMapCell, rhs: LayeredMapCell) -> Bool {
        lhs.tileCell == rhs.tileCell && lhs.constructionCell == rhs.constructionCell
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(tileCell)
        hasher.combine(constructionCell)
    }
}
