//
//  StatusLight.swift
//  JASS 2023 Smart City
//
//  Created by Philipp Zagar on 31.03.23.
//

import Foundation

enum StatusLight {
    // MARK: - StatusVehicle
    struct StatusLight: Codable {
        let type: Self.Message
        let data: DataClass
        
        enum Message: String, Codable {
            case status = "status_traffic-light"
        }
    }

    // MARK: - DataClass
    struct DataClass: Codable {
        let color: LightColor
        
        enum LightColor: String, Codable {
            case red = "red"
            case yellow = "yellow"
            case green = "green"
            case prepare = "prepare"    // red and yellow at the same time
        }
    }
}
