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
    @State private var currentPosition: CGPoint = .zero
    @GestureState private var gestureOffset: CGSize = .zero
    
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
                    GeometryReader { geometryInner in
                        LazyVGrid(columns: self.columns, spacing: 0) {
                            ForEach(self.cells, id: \.tileCell) { cell in
                                TileCellView(cell: cell)
                            }
                        }
                        .background(Color.black)
                        .onAppear {
                            self.subviewSize = geometryInner.size
                            self.subviewFrame = geometryInner.frame(in: .global)
                        }
                    }
                    
                    DuckieMapView(subviewSize: self.subviewSize)
                }
                .scaleEffect(currentScale * gestureScale)
                .offset(x: currentPosition.x + gestureOffset.width,
                        y: currentPosition.y + gestureOffset.height)
                .gesture(magnification.simultaneously(with: drag))
            }
    }
}

extension MapGridView {
    var cells: [LayeredMapCell] {
        self.sortedTiles
            .map { tileCell in
                let constructionCell = self.model.constructionCells.first { constructionCell in
                    constructionCell.i == tileCell.i && constructionCell.j == tileCell.j
                }
                
                return .init(tileCell: tileCell, constructionCell: constructionCell)
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
