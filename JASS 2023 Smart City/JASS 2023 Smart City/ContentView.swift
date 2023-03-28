//
//  ContentView.swift
//  JASS 2023 Smart City
//
//  Created by Philipp Zagar on 27.03.23.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var model: CityModel
    let interface = WebsocketConnection()
    
    var body: some View {
        NavigationView {
            TabView {
                TileRowList()
                    .tabItem {
                        Label("First", systemImage: "1.circle")
                    }
                MapGridView(cityModel: model)
                    .tabItem {
                        Label("Second", systemImage: "2.circle")
                    }
                TestImagesView()
                    .tabItem {
                        Label("Third", systemImage: "3.circle")
                    }
                Button("Add construction site", action: interface.planningConstructionSite)
                    .tabItem {
                        Label("Forth", systemImage: "4.circle")
                    }
            }
            .navigationTitle("JASS 2023 Cyprus - City Manager")
        }
        .navigationViewStyle(.stack)
        .task {
            self.model.tiles = Parser.parse(tilesYAML: "tiles", framesYAML: "frames") ?? ["defaultTile" : TileCell.defaultTile]
            
            let layeredMap = LayeredMap(layers: [
                0: TileLayer(data: [TileCell.defaultTile]),
                1: DuckieLayer(data: [DuckieCell.defaultTile])
            ])
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
