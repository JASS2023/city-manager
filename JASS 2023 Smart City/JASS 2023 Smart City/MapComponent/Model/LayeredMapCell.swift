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
    @Published var serviceCell: ServiceCell?
    @Published var obstacleCell: ObstacleCell?
    
    init(tileCell: TileCell, constructionCell: ConstructionCell?, serviceCell: ServiceCell?, obstacleCell: ObstacleCell?) {
        self.tileCell = tileCell
        self.constructionCell = constructionCell
        self.serviceCell = serviceCell
        self.obstacleCell = obstacleCell
    }
    
    static func == (lhs: LayeredMapCell, rhs: LayeredMapCell) -> Bool {
        lhs.tileCell == rhs.tileCell && lhs.constructionCell == rhs.constructionCell && lhs.serviceCell == rhs.serviceCell && lhs.obstacleCell == rhs.obstacleCell
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(tileCell)
        hasher.combine(constructionCell)
        hasher.combine(serviceCell)
        hasher.combine(obstacleCell)
    }
}
