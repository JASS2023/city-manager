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
            host: "192.168.0.3",
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
    
    mutating func subscribe() async {
        let listener = client.createPublishListener()
        
        for await result in listener {
            switch result {
            case .success(let packet):
                //print("Received MQQT packet")
                
                var buffer = packet.payload
                self.receivedPackages += 1
                
                if packet.topicName.contains(try! Regex(#"^vehicle\/\d+\/status$"#)) {
                    if let data = try? buffer.readJSONDecodable(VehicleStatus.VehicleStatus.self, decoder: Self.jsonDecoder, length: buffer.readableBytes) {
                        //print(data)
                        //let layer: DuckieLayer = CityModel.shared.map.getLayer()
                        DuckieModel.shared.duckieMap.update(vehicleStatus: data)
                        //layer.update(vehicleStatus: data)
                        if(self.receivedPackages % 1 == 0) {    // TODO 
                            DuckieMapViewModel.shared.duckieMap = DuckieModel.shared.duckieMap
                        }
                    }
                } else {
                    print("Error: Unknown topic!")
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
        case vehicleStatus = "vehicle/+/status"
    }
}
