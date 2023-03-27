//
//  ContentView.swift
//  JASS 2023 Smart City
//
//  Created by Philipp Zagar on 27.03.23.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var model: CityModel
    var interface = Interface()
    
    var body: some View {
        NavigationView {
            Button("Add construction site", action: interface.planningConstructionSite)
            TabView {
                TileRowList()
                    .tabItem {
                        Label("First", systemImage: "1.circle")
                    }
                MapGridView()
                    .tabItem {
                        Label("Second", systemImage: "2.circle")
                    }
                TestImagesView()
                    .tabItem {
                        Label("Third", systemImage: "3.circle")
                    }
            }
            .navigationTitle("Tiles")
        }
        .navigationViewStyle(.stack)
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