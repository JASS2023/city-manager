//
//  MapGridView.swift
//  JASS 2023 Smart City
//
//  Created by Philipp Zagar on 27.03.23.
//

import Foundation
import SwiftUI

struct MapPresentationGridView: View {
    @EnvironmentObject var model: CityModel
    
    @State private var subviewSize: CGSize = .zero
    
    @State private var currentScale: CGFloat = 1.0
    @GestureState private var gestureScale: CGFloat = 1.0
    @State private var currentPosition: CGPoint = .zero
    @GestureState private var gestureOffset: CGSize = .zero
    
    @State private var showPopup = false
    @State private var selectedCell: LayeredMapCell? = nil
    
    var body: some View {
        let magnification = MagnificationGesture()
            .updating($gestureScale) { (value, state, _) in
                state = value
            }
            .onEnded { value in
                self.currentScale *= value
            }
        
        let drag = DragGesture()
            .updating($gestureOffset) { (value, state, _) in
                state = value.translation
            }
            .onEnded { value in
                self.currentPosition = CGPoint(x: self.currentPosition.x + value.translation.width,
                                                y: self.currentPosition.y + value.translation.height)
            }
        
            VStack {
                Spacer()
                
                ZStack {
                    Group {
                        GeometryReader { geometryInner in
                            LazyVGrid(columns: self.columns, spacing: 0) {
                                ForEach(self.cells, id: \.tileCell) { cell in
                                    TileCellView(cell: cell, angle: 180.0)
                                        .onTapGesture {
                                            self.selectedCell = cell
                                            self.showPopup = true
                                        }
                                }
                            }
                            .background(Color.black)
                            .onAppear {
                                self.subviewSize = geometryInner.size
                            }
                        }
                        
                        TrafficLightMapView(subviewSize: self.subviewSize)
                        
                        DuckiePresentationMapView(subviewSize: self.subviewSize)
                    }
                    .blur(radius: self.showPopup ? 8 : 0)
                    
                    AddCellPopupView(showPopup: self.$showPopup, selectedCell: self.selectedCell)
                }
                .scaleEffect(currentScale * gestureScale)
                .offset(x: currentPosition.x + gestureOffset.width,
                        y: currentPosition.y + gestureOffset.height)
                .gesture(magnification.simultaneously(with: drag))
            }
    }
}

extension MapPresentationGridView {
    var cells: [LayeredMapCell] {
        self.sortedTiles
            .map { tileCell in
                let constructionCell = self.model.constructionCells.first { constructionCell in
                    constructionCell.i == tileCell.i && constructionCell.j == tileCell.j
                }
                
                let serviceCell = self.model.serviceCells.first { serviceCell in
                    serviceCell.i == tileCell.i && serviceCell.j == tileCell.j
                }
                
                return .init(tileCell: tileCell, constructionCell: constructionCell, serviceCell: serviceCell)
            }
    }
    
    private var sortedTiles: [TileCell] {
        self.model.tileCells.sorted { (tile1, tile2) -> Bool in
            // Sort tiles according to the global coordinate system
            if tile1.j == tile2.j {
                return tile1.i > tile2.i
            } else {
                return tile1.j < tile2.j
            }
        }
        // TODO Fix
        // Crops the irrelevant tiles
        .filter { tile in
            tile.i > 0 && tile.i < 7
        }
        .filter { tile in
            tile.j > 6 && tile.j < 13
        }
    }
    
    var columns: [GridItem] {
        Array(repeating: GridItem(.flexible(), spacing: 0), count: self.rowsTiles)
    }
    
    var rowsTiles: Int {
        return 6
        /*
        return self.sortedTiles.count
        
        let rows = self.sortedTiles.reduce(into: 0) { partialResult, element in
            if(partialResult < element.i) {
                partialResult = element.i
            }
        }
        return 6
        return rows + 1
         */
    }
    
    var columnsTiles: Int {
        return 6
        /*
        return self.sortedTiles.count
        
        let columns = self.sortedTiles.reduce(into: 0) { partialResult, element in
            if(partialResult < element.j) {
                partialResult = element.j
            }
        }
        return 6
        return columns + 1
         */
    }
}
