//
//  ContentView.swift
//  JASS 2023 Smart City
//
//  Created by Philipp Zagar on 27.03.23.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var model: CityModel
    @State private var selectedTab = 1
    
    @State var timeNow = ""
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    var dateFormatter: DateFormatter {
        let fmtr = DateFormatter()
        fmtr.dateFormat = "hh:mm:ss a"
        return fmtr
    }
    
    var body: some View {
        NavigationView {
            TabView(selection: self.$selectedTab){
                MapGridView()
                    .tabItem {
                        Label("Overall Map", systemImage: "map")
                    }
                    .tag(1)
                
                MapPresentationGridView()
                    .tabItem {
                        Label("Presentation Map", systemImage: "building")
                    }
                    .tag(2)
                
                TileRowList()
                    .tabItem {
                        Label("Tiles", systemImage: "0.square")
                    }
                    .tag(3)
                /*
                 TestImagesView()
                 .tabItem {
                 Label("Third", systemImage: "3.circle")
                 }
                 */
            }
            .navigationTitle("JASS 2023 Cyprus - City Manager - " + timeNow)
            .onAppear {
                self.selectedTab = 2
            }
            .onReceive(timer) { _ in
                self.timeNow = dateFormatter.string(from: Date())
            }
        }
        .navigationViewStyle(.stack)
        .task {
            let tileCells = Parser.parse(tilesYAML: "tiles", framesYAML: "frames") ?? ["defaultTile" : TileCell.defaultTile]
            
            let constructionCells: [ConstructionCell] = []
            
            self.model.map = LayeredMap(layers: [
                TileLayer(data: Array(tileCells.values)),
                // ConstructionLayer(data: constructionCells),
                ConstructionLayer(data: constructionCells),
                ServiceLayer(data: []),
                TrafficLightLayer(data: [.defaultTrafficLight, .defaultTrafficLight2]),
                ObstacleLayer(data: []),
                DuckieLayer(data: [])
            ])
            
            self.model.mqtt = await MQTT(
                topics: MQTT.Topics.statusVehicle,
                    MQTT.Topics.statusConstructionSite,
                    MQTT.Topics.obstacleVehicle,
                    MQTT.Topics.statusLight
            )
            
            await self.model.mqtt?.subscribe()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
