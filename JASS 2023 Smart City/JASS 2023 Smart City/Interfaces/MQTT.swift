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
    static let jsonEncoder: JSONEncoder = {
        let json = JSONEncoder()
        json.dateEncodingStrategy = .iso8601
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
                //print(packet)
                
                let topicEnum = Self.Topics(topic: packet.topicName)
                                
                switch Self.Topics(topic: packet.topicName) {
                case .statusVehicle:
                    if let data = try? buffer.readJSONDecodable(StatusVehicle.StatusVehicle.self, decoder: Self.jsonDecoder, length: buffer.readableBytes) {                        
                        DuckieModel.shared.duckieMap.update(vehicleStatus: data)
                        DuckieMapViewModel.shared.duckieMap = DuckieModel.shared.duckieMap
                        DuckiePresentationMapViewModel.shared.duckieMap = DuckieModel.shared.duckieMap
                    } else {
                        print("Error while decoding event - \(String(describing: topicEnum.rawValue))")
                    }
                case .statusConstructionSite:
                    //todo: There is something wrong with decode! Have a look why
                    if let data = try? buffer.readJSONDecodable(StatusConstructionSite.StatusConstructionSite.self, length: buffer.readableBytes) {
                        
                        let layer: ConstructionLayer = CityModel.shared.map.getLayer()
                        layer.update(constructionSiteStatus: data)
                        CityModel.shared.trigger()
                    } else {
                        print("Error while decoding event - \(String(describing: topicEnum.rawValue))")
                    }
                    
                case .obstacleVehicle:
                    if let data = try? buffer.readJSONDecodable(StatusObstacle.StatusObstacle.self, length: buffer.readableBytes) {
                        print("Obstacle detected")
                        print(data)
                        
                        let layer: ObstacleLayer = CityModel.shared.map.getLayer()
                        layer.update(obstacleStatus: data)
                        CityModel.shared.trigger()
                    } else {
                        print("Error while decoding event - \(String(describing: topicEnum.rawValue))")
                    }
                    
                case .statusLight:
                    if let data = try? buffer.readJSONDecodable(StatusLight.StatusLight.self, length: buffer.readableBytes) {
                        //print(data)
                        
                        let idTrafficLight = Int(packet.topicName.last?.description ?? "1") ?? 1
                        
                        let layer: TrafficLightLayer = CityModel.shared.map.getLayer()
                        layer.update(id: idTrafficLight, statusLightData: data)
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
        guard let encodedPayload = try? Self.jsonEncoder.encode(data) else {
            print("Error while encoding event")
            return
        }
        
        print(String(data: encodedPayload, encoding: .utf8)!)
        
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
        case obstacleVehicle = "vehicle/+/obstruction"
        case statusLight = "traffic-light/1/+"
        case none = "none"
        
        init(topic: String) {
            if topic.contains(try! Regex(#"^vehicle\/\d+\/status$"#)) {
                self = .statusVehicle
            } else if topic.contains(try! Regex(#"^construction\/\d+\/status$"#)) {
                self = .statusConstructionSite
            } else if topic.contains(try! Regex(#"^vehicle\/\d+\/obstruction$"#)) {
                self = .obstacleVehicle
            } else if topic.contains(try! Regex(#"^traffic-light\/1\/\d+$"#)) {
                self = .statusLight
            } else {
                self = .none
            }
        }
        
        func publishingTopic(id: Int) -> String {
            self.rawValue.replacingOccurrences(of: "+", with: id.description)
        }
    }
}
