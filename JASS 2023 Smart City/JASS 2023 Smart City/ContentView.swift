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
                Button("Add construction site", action: CityModel.interface.planningConstructionSite)
                    .tabItem {
                        Label("Forth", systemImage: "4.circle")
                    }
            }
            .navigationTitle("JASS 2023 Cyprus - City Manager")
        }
        .navigationViewStyle(.stack)
        .task {
            let tileCells = Parser.parse(tilesYAML: "tiles", framesYAML: "frames") ?? ["defaultTile" : TileCell.defaultTile]
            
            let duckieCells = [
                DuckieCell.defaultTile
            ]
             
            self.model.map = LayeredMap(layers: [
                0: TileLayer(data: Array(tileCells.values)),
                1: DuckieLayer(data: duckieCells)
            ])
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
