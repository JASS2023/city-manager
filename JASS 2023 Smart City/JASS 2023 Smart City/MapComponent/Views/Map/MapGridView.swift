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
    @State private var subviewSize: CGSize = .zero
    @State private var subviewFrame: CGRect = .zero
    
    @State private var currentScale: CGFloat = 1.0
    @GestureState private var gestureScale: CGFloat = 1.0
    
    var body: some View {
        let magnification = MagnificationGesture()
            .updating($gestureScale) { (value, state, _) in
                state = value
            }
            .onEnded { value in
                self.currentScale *= value
            }
        
        VStack {
            Spacer()
            
            ZStack {
                GeometryReader { geometryInner in
                    LazyVGrid(columns: self.columns, spacing: 0) {
                        ForEach(self.cells, id: \.self) { cell in
                            TileCellView(cell: cell)
                        }
                    }
                    .background(Color.black)
                    .onAppear {
                        self.subviewSize = geometryInner.size
                        self.subviewFrame = geometryInner.frame(in: .global)
                    }
                }
                
                ForEach(model.duckieCells) { duckieCell in
                    ForEach(duckieCell.duckies) { duckie in
                        TileType.duckie.image
                            .resizable()
                            .scaledToFit()
                            .rotationEffect(Angle(degrees: duckie.yaw), anchor: .center)
                            .frame(width: 25, height: 25)
                            .position(getPosition(for: self.subviewSize, cell: duckie))
                        //.offset(x: 25, y: 25)
                    }
                }
                
                ForEach(model.constructionCells) { consturctionCell in
                    TileType.cone.image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25, height: 25)
                        .backgroundStyle(Color.red.opacity(0.5))
                    //.offset(x: 25, y: 25)
                    
                }
                
//                Button("Add construction") {
//                    Task {
//                        let mqtt = try await MQTT(topics: MQTT.Topics.planConstructionSite)
//                        await mqtt.publish(topic: MQTT.Topics.planConstructionSite, data: PlanConstructionSite.PlanConstructionSite.init(type: MQTT.Topics.planConstructionSite.rawValue, data:  PlanConstructionSite.ConstructionSite(id: UUID(), coordinates: [PlanConstructionSite.Coordinate.init(x: 10.0, y: 10.0, x_abs: 10.0, y_abs: 10.0)], startDateTime: Date(), endDateTime: Date(), maximumSpeed: 8.8, trafficLights: PlanConstructionSite.TrafficLights(id1: UUID(), id2: UUID()))))
//                    }
//                }
                
                
            }
            .scaleEffect(currentScale * gestureScale)
            .gesture(magnification)
        }
    }
    
    func getPosition(for size: CGSize, cell: Duckie) -> CGPoint {
        let widthCell = size.width / 13.9
        let heightCell = size.height / 15.8
        
        return CGPoint(x: (cell.i + 1) * widthCell, y: (cell.j + 1) * heightCell)   // TODO: +1 fix
    }
}

extension MapGridView {
    var cells: [LayeredMapCell] {
        self.sortedTiles
            .map { tilecell in
                let duckieCell = self.model.duckieCells.first { duckieCell in
                    duckieCell.i == tilecell.i && duckieCell.j == tilecell.j
                }
                
                let constructionCell = self.model.constructionCells.first { constructionCell in
                    constructionCell.i == tilecell.i && constructionCell.j == tilecell.j
                }
                
                return .init(tileCell: tilecell, duckieCell: duckieCell, constructionCell: constructionCell)
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
        // TODO Fix
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
