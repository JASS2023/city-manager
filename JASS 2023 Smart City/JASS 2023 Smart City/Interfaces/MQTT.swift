//
//  MQTTClient.swift
//  JASS 2023 Smart City
//
//  Created by Philipp Zagar on 28.03.23.
//

import Foundation
import NIO
import MQTTNIO

@MainActor
struct MQTT {
    private let client: MQTTClient
    private var receivedPackages: Int
    private let semaphore = DispatchSemaphore(value: 1)
    static let jsonDecoder: JSONDecoder = {
        let json = JSONDecoder()
        json.dateDecodingStrategy = .iso8601
        return json
    }()
    
    init(topics: MQTT.Topics...) async {
        self.client = MQTTClient(
            host: "192.168.0.223",
            port: 1883,
            identifier: "CityManager",
            eventLoopGroupProvider: .createNew
        )
        
        self.receivedPackages = 0
        
        do {
            try await client.connect()
            print("MQTT succesfully connected")
        } catch {
            print("Error while connecting - \(error)")
        }
        
        let subscriptions = topics.map { topic in
            MQTTSubscribeInfo(topicFilter: topic.rawValue, qos: .atMostOnce)
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
                var buffer = packet.payload
                //self.receivedPackages += 1
                
                let topicEnum = Self.Topics(topic: packet.topicName)
                
                switch Self.Topics(topic: packet.topicName) {
                case .statusVehicle:
                    if let data = try? buffer.readJSONDecodable(StatusVehicle.StatusVehicle.self, decoder: Self.jsonDecoder, length: buffer.readableBytes) {
                        //print(data)

                        DuckieModel.shared.duckieMap.update(vehicleStatus: data)
                        DuckieMapViewModel.shared.duckieMap = DuckieModel.shared.duckieMap
                    } else {
                        print("Error while decoding event - \(String(describing: topicEnum.rawValue))")
                    }
                case .statusConstructionSite:
                    if let data = try? buffer.readJSONDecodable(StatusConstructionSite.StatusConstructionSite.self, length: buffer.readableBytes) {
                        print(data)
                        
                        let layer: ConstructionLayer = CityModel.shared.map.getLayer()
                        layer.update(constructionSiteStatus: data)
                        CityModel.shared.trigger()
                    } else {
                        print("Error while decoding event - \(String(describing: topicEnum.rawValue))")
                    }
                case .none: print("Unknown type received by MQTT")
                default: print("Error during decoding")
                }
            case .failure(let error):
                print("Error while receiving event - \(error)")
            }
        }
    }
    
    func publish<T: Codable>(topic: Self.Topics, data: T, id: Int = 1) async {
        guard let encodedPayload = try? JSONEncoder().encode(data) else {
            print("Error while encoding event")
            return
        }
        
        print(topic.publishingTopic(id: id))
        
        do {
            try await client.publish(
                to: topic.publishingTopic(id: id),
                payload: ByteBuffer(data: encodedPayload),
                qos: .atLeastOnce
            )
            
            print("Sent MQQT packet")
        } catch {
            print("Error while writing event to broker - \(error)")
        }
    }
}

extension MQTT {
    enum Topics: String {
        case planConstructionSite = "construction/+/plan"
        case statusConstructionSite = "construction/+/status"
        case planService = "service/+/plan"
        case statusService = "service/+/status"
        case statusVehicle = "vehicle/+/status"
        case none = "none"
        
        init(topic: String) {
            if topic.contains(try! Regex(#"^vehicle\/\d+\/status$"#)) {
                self = .statusVehicle
            } else if topic.contains(try! Regex(#"^construction\/\d+\/status$"#)) {
                self = .statusConstructionSite
            } else {
                self = .none
            }
        }
        
        func publishingTopic(id: Int) -> String {
            self.rawValue.replacingOccurrences(of: "+", with: id.description)
        }
    }
}
