//
//  ContentView.swift
//  JASS 2023 Smart City
//
//  Created by Philipp Zagar on 27.03.23.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var model: CityModel
    
    var body: some View {
        NavigationView {
            
            List {
                ForEach(Array(self.model.tiles.keys), id: \.self) { key in
                    TileRowView(key: key, tile: self.model.tiles[key] ?? Tile.defaultTile)
                }
            }
             
            //TestImages()
            .navigationTitle("Tiles")
        }
        .task {
            self.model.tiles = Parser.parse(tilesYAML: "tiles", framesYAML: "frames") ?? ["defaultTile" : Tile.defaultTile]
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
