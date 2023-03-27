//
//  PlanningConstructionSite.swift
//  JASS 2023 Smart City
//
//  Created by sunny wang on 2023/3/27.
//

import Foundation
import Starscream

class Interface {
    var connection: Bool
    var socket: WebSocket
    
    init() {
        socket = WebSocket(request: URLRequest(url: URL(string: "wss://socketsbay.com/wss/v2/1/demo/27apo")!))
        connection = false;
        socket.onEvent = { event in
            switch event {
            case .connected(_):
                self.connection = true
                print("WebSocket connected.")
                break;
            case .disconnected(_, _):
                self.connection = false
                print("WebSocket disconnected.")
                break;
            case .text(let text):
                let decoder = JSONDecoder()
                if let jsonData = text.data(using: .utf8),
                   let message = try? decoder.decode(WebSocketMessage.self, from: jsonData) {
                    print(message.topic)
                    // listen to built updates
                    if message.topic == "construction site" {
                        print("🚧 A construction site has been built!")
                    }
                }
                break;
            default: break
            }
        }
        socket.connect()
    }
    
    public func planningConstructionSite() {
        let mockedConstructionSite = RequestConstructionSite(id: UUID(), coordinates: [Coordinate(x: 1, y: 2), Coordinate(x: 1, y: 3)], trafficLights: TrafficLights(id1: UUID(), id2: UUID()))
        let encoder = JSONEncoder()
        let jsonData = try! encoder.encode(mockedConstructionSite)
        let jsonString = String(data: jsonData, encoding: .utf8)!
        let planningMessage = WebSocketMessage(topic: "plan construction site", data: jsonString)
        if connection {
            socket.write(string: planningMessage.toJSONString())
        }
    }
}

