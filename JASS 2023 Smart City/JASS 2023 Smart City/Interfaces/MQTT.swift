//
//  MQTTClient.swift
//  JASS 2023 Smart City
//
//  Created by Philipp Zagar on 28.03.23.
//

import Foundation
import NIO
import MQTTNIO

struct MQTT {
    private let client: MQTTClient
    
    init(topics: MQTT.Topics...) async {
        self.client = MQTTClient(
            host: "192.168.0.3",
            port: 1883,
            identifier: "CityManager",
            eventLoopGroupProvider: .createNew
        )
        
        do {
            try await client.connect()
            print("MQTT succesfully connected")
        } catch {
            print("Error while connecting - \(error)")
        }
        
        let subscriptions = topics.map { topic in
            MQTTSubscribeInfo(topicFilter: topic.rawValue, qos: .atLeastOnce)
        }
        
        do {
            _ = try await client.subscribe(to: subscriptions)
        } catch {
            print("Error while subscribing to topics - \(error)")
        }
    }
    
    func subscribe() async {
        let listener = client.createPublishListener()
        
        for await result in listener {
            switch result {
            case .success(let packet):
                print("Received MQQT packet")
                
                let topicEnum = Self.Topics(rawValue: packet.topicName)
                var buffer = packet.payload
                
                switch topicEnum {
                case .vehicleStatus:
                    if let data = try? buffer.readJSONDecodable(VehicleStatus.VehicleStatus.self, length: buffer.readableBytes) {
                        print("Error while decoding event - \(String(describing: topicEnum?.rawValue))")
                        print(data)
                        
                        let layer: DuckieLayer = CityModel.shared.map.getLayer()
                        layer.update(vehicleStatus: data)
                        CityModel.shared.trigger()
                    }
                case .none: print("Error during decoding")
                default: print("Error during decoding")
                }
            case .failure(let error):
                print("Error while receiving event - \(error)")
            }
        }
    }
    
    func publish<T: Codable>(topic: Self.Topics, data: T) async {
        guard let encodedPayload = try? JSONEncoder().encode(data) else {
            print("Error while encoding event")
            return
        }
        
        do {
            try await client.publish(
                to: topic.rawValue,
                payload: ByteBuffer(data: encodedPayload),
                qos: .atLeastOnce
            )
            
            print("Sent MQQT packet")
        } catch {
            print("Error while receiving event - \(error)")
        }
    }
}

extension MQTT {
    enum Topics: String {
        case planConstructionSite = "plan_construction_site"
        case planService = "plan_service"
        case vehicleStatus = "vehicle/12/status"
    }
}
