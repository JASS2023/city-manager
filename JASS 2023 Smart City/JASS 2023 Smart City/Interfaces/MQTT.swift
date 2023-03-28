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
                case .planConstructionSite:
                    guard let data = try? buffer.readJSONDecodable(PlanConstructionSite.PlanConstructionSite.self, length: buffer.readableBytes) else {
                        print("Error while decoding event - \(String(describing: topicEnum?.rawValue))")
                        return
                    }
                    
                    print(data)
                case .planService:
                    guard let data = try? buffer.readJSONDecodable(PlanService.PlanService.self, length: buffer.readableBytes) else {
                        print("Error while decoding event - \(String(describing: topicEnum?.rawValue))")
                        return
                    }
                    
                    print(data)
                case .none: print("Error during decoding")
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
    }
}
