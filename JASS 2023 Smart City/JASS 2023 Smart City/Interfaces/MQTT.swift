//
//  MQTTClient.swift
//  JASS 2023 Smart City
//
//  Created by Philipp Zagar on 28.03.23.
//

import Foundation
import MQTTNIO

struct MQTT {
    private let client: MQTTClient
    
    init() async {
        self.client = MQTTClient(
            host: "broker.mtze.me",
            port: 30_000,
            identifier: "CityManager",
            eventLoopGroupProvider: .createNew
        )
        
        do {
            try await client.connect()
            print("MQTT succesfully connected")
        } catch {
            print("Error while connecting - \(error)")
        }
    }
    
    func subscribeTopic<T: Codable>(name: String, type: T.Type) async {
        let subscription = MQTTSubscribeInfo(topicFilter: name, qos: .atLeastOnce)
        do {
            _ = try await client.subscribe(to: [subscription])
        } catch {
            print("Error while subscribing to topic - \(error)")
        }
        
        let listener = client.createPublishListener()
        for await result in listener {
            switch result {
            case .success(let packet):
                if packet.topicName == name {
                    var buffer = packet.payload
                    guard let data = try? buffer.readJSONDecodable(type, length: buffer.readableBytes) else {
                        print("Error while decoding event - \(type.self)")
                        return
                    }
                    print(data)
                }
            case .failure(let error):
                print("Error while receiving event - \(error)")
            }
        }
    }
}
