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
                MapGridView()
                    .tabItem {
                        Label("Second", systemImage: "2.circle")
                    }
                TestImagesView()
                    .tabItem {
                        Label("Third", systemImage: "3.circle")
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
            
            let constructionCells = [
                ConstructionCell.defaultTile
            ]
             
            self.model.map = LayeredMap(layers: [
                TileLayer(data: Array(tileCells.values)),
                // ConstructionLayer(data: constructionCells),
                ConstructionLayer(data: []),
                DuckieLayer(data: [])
            ])
            
            /*
            let layer: DuckieLayer = CityModel.shared.map.getLayer()
            layer.update(vehicleStatus: .init(
                type: "vehicle_status",
                data: .init(id: 0, name: "defaultDuckie", timestamp: .now, coordinates: .init(
                    x: 0,
                    y: 0,
                    yaw: 0,
                    xAbs: 123,
                    yAbs: 123)
                )
            ))
            layer.update(vehicleStatus: .init(
                type: "vehicle_status",
                data: .init(id: 1, name: "defaultDuckie", timestamp: .now, coordinates: .init(
                    x: 1,
                    y: 1,
                    yaw: 10,
                    xAbs: 123,
                    yAbs: 123)
                )
            ))
            layer.update(vehicleStatus: .init(
                type: "vehicle_status",
                data: .init(id: 2, name: "defaultDuckie", timestamp: .now, coordinates: .init(
                    x: 2,
                    y: 2,
                    yaw: 20,
                    xAbs: 123,
                    yAbs: 123)
                )
            ))
            layer.update(vehicleStatus: .init(
                type: "vehicle_status",
                data: .init(id: 3, name: "defaultDuckie", timestamp: .now, coordinates: .init(
                    x: 3,
                    y: 3,
                    yaw: 30,
                    xAbs: 123,
                    yAbs: 123)
                )
            ))
            layer.update(vehicleStatus: .init(
                type: "vehicle_status",
                data: .init(id: 4, name: "defaultDuckie", timestamp: .now, coordinates: .init(
                    x: 4,
                    y: 4,
                    yaw: 0,
                    xAbs: 123,
                    yAbs: 123)
                )
            ))
            layer.update(vehicleStatus: .init(
                type: "vehicle_status",
                data: .init(id: 5, name: "defaultDuckie", timestamp: .now, coordinates: .init(
                    x: 5,
                    y: 5,
                    yaw: 0,
                    xAbs: 123,
                    yAbs: 123)
                )
            ))
            layer.update(vehicleStatus: .init(
                type: "vehicle_status",
                data: .init(id: 6, name: "defaultDuckie", timestamp: .now, coordinates: .init(
                    x: 6,
                    y: 6,
                    yaw: 0,
                    xAbs: 123,
                    yAbs: 123)
                )
            ))
            layer.update(vehicleStatus: .init(
                type: "vehicle_status",
                data: .init(id: 7, name: "defaultDuckie", timestamp: .now, coordinates: .init(
                    x: 7,
                    y: 7,
                    yaw: 0,
                    xAbs: 123,
                    yAbs: 123)
                )
            ))
            layer.update(vehicleStatus: .init(
                type: "vehicle_status",
                data: .init(id: 8, name: "defaultDuckie", timestamp: .now, coordinates: .init(
                    x: 8,
                    y: 8,
                    yaw: 0,
                    xAbs: 123,
                    yAbs: 123)
                )
            ))
            layer.update(vehicleStatus: .init(
                type: "vehicle_status",
                data: .init(id: 9, name: "defaultDuckie", timestamp: .now, coordinates: .init(
                    x: 9,
                    y: 9,
                    yaw: 0,
                    xAbs: 123,
                    yAbs: 123)
                )
            ))
            layer.update(vehicleStatus: .init(
                type: "vehicle_status",
                data: .init(id: 10, name: "defaultDuckie", timestamp: .now, coordinates: .init(
                    x: 10,
                    y: 10,
                    yaw: 0,
                    xAbs: 123,
                    yAbs: 123)
                )
            ))
            layer.update(vehicleStatus: .init(
                type: "vehicle_status",
                data: .init(id: 11, name: "defaultDuckie", timestamp: .now, coordinates: .init(
                    x: 11,
                    y: 11,
                    yaw: 0,
                    xAbs: 123,
                    yAbs: 123)
                )
            ))
            layer.update(vehicleStatus: .init(
                type: "vehicle_status",
                data: .init(id: 12, name: "defaultDuckie", timestamp: .now, coordinates: .init(
                    x: 12,
                    y: 12,
                    yaw: 0,
                    xAbs: 123,
                    yAbs: 123)
                )
            ))
            */
            
            let mqtt = await MQTT(topics: MQTT.Topics.vehicleStatus)
            
            /*
            let mockedConstructionSite = PlanConstructionSite.PlanConstructionSite(type: "test", data: .init(constructionSite: .init(id: .init(), coordinates: [.init(x: 1, y: 2, quadrant: 3)], startDateTime: .now, endDateTime: .now, maximumSpeed: 12.12, trafficLights: .init(id1: .init(), id2: .init()))))
             */
            
            //await mqtt.publish(topic: MQTT.Topics.vehicleStatus, data: mockedConstructionSite)
            
            await mqtt.subscribe()
            
//            let layer: DuckieLayer = self.model.map.getLayer()
//            layer.addNewCell(cell: DuckieCell(i: 10, j: 10))
//            
            /*
            DispatchQueue.main.schedule(after: .init(.now() + .seconds(2)), tolerance: .zero, options: .none) {
                self.model.map.layers[1] = DuckieLayer(data: [.init(i: 8, j: 10)])
                
                // Works now
                /*
                let layer: DuckieLayer = self.model.map.getLayer()
                layer.addNewCell(cell: DuckieCell(i: 10, j: 10))
                 */

                self.model.trigger()
            }
            
            DispatchQueue.main.schedule(after: .init(.now() + .seconds(4)), tolerance: .zero, options: .none) {
                self.model.map.layers[1] = DuckieLayer(data: [.init(i: 8, j: 9)])
                self.model.trigger()
            }
            
            DispatchQueue.main.schedule(after: .init(.now() + .seconds(6)), tolerance: .zero, options: .none) {
                self.model.map.layers[1] = DuckieLayer(data: [.init(i: 8, j: 8)])
                self.model.trigger()
            }
            
            DispatchQueue.main.schedule(after: .init(.now() + .seconds(8)), tolerance: .zero, options: .none) {
                self.model.map.layers[1] = DuckieLayer(data: [.init(i: 8, j: 7)])
                self.model.trigger()
            }
            
            DispatchQueue.main.schedule(after: .init(.now() + .seconds(10)), tolerance: .zero, options: .none) {
                self.model.map.layers[1] = DuckieLayer(data: [.init(i: 8, j: 6)])
                self.model.trigger()
            }
            
            DispatchQueue.main.schedule(after: .init(.now() + .seconds(12)), tolerance: .zero, options: .none) {
                self.model.map.layers[1] = DuckieLayer(data: [.init(i: 9, j: 6)])
                self.model.trigger()
            }
            
            DispatchQueue.main.schedule(after: .init(.now() + .seconds(14)), tolerance: .zero, options: .none) {
                self.model.map.layers[1] = DuckieLayer(data: [.init(i: 10, j: 6)])
                self.model.trigger()
            }
            
            DispatchQueue.main.schedule(after: .init(.now() + .seconds(16)), tolerance: .zero, options: .none) {
                self.model.map.layers[1] = DuckieLayer(data: [.init(i: 11, j: 6)])
                self.model.trigger()
            }
             */
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
