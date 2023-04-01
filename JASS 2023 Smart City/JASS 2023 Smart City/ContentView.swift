//
//  ContentView.swift
//  JASS 2023 Smart City
//
//  Created by Philipp Zagar on 27.03.23.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var model: CityModel
    @State var timeNow = ""
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    var dateFormatter: DateFormatter {
        let fmtr = DateFormatter()
        fmtr.dateFormat = "hh:mm:ss a"
        return fmtr
    }
    
    var body: some View {
        NavigationView {
            TabView {
                MapGridView()
                    .tabItem {
                        Label("Overall Map", systemImage: "map")
                    }
                
                MapPresentationGridView()
                    .tabItem {
                        Label("Presentation Map", systemImage: "building")
                    }
                
                TileRowList()
                    .tabItem {
                        Label("Tiles", systemImage: "0.square")
                    }
                /*
                 TestImagesView()
                 .tabItem {
                 Label("Third", systemImage: "3.circle")
                 }
                 */
            }
            .navigationTitle("JASS 2023 Cyprus - City Manager - " + timeNow)
            .onReceive(timer) { _ in
                self.timeNow = dateFormatter.string(from: Date())
            }
        }
        .navigationViewStyle(.stack)
        .task {
            let tileCells = Parser.parse(tilesYAML: "tiles", framesYAML: "frames") ?? ["defaultTile" : TileCell.defaultTile]
            
            let constructionCells: [ConstructionCell] = []
            /*
             .init(i: 8, j: 8, quadrants: [
             .lowerRight,
             .upperRight
             ]),
             .init(i: 8, j: 7, quadrants: [
             .lowerRight,
             .upperRight
             ])
             ]
             */
            
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
            
            /*
             await self.model.mqtt?.publish(
             topic: .planConstructionSite,
             data: PlanConstructionSite.PlanConstructionSite(
             type: "plan_construction_site",
             data: .init(
             id: .init(),
             coordinates: [
             .init(x: 7, y: 8,
             quadrants: [
             .upperRight,
             .lowerRight
             ],
             x_abs: 1.1, y_abs: 2.1
             )
             ],
             startDateTime: .now,
             endDateTime: .now.addingTimeInterval(10),
             maximumSpeed: 10.1,
             trafficLights: .init(id1: .init(), id2: .init())
             )
             ),
             id: .init()
             )
             */
            
            await self.model.mqtt?.subscribe()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
