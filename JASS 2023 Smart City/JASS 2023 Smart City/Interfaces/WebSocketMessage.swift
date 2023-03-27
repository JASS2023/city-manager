//
//  WebSocketMessage.swift
//  JASS 2023 Smart City
//
//  Created by sunny wang on 2023/3/27.
//

import Foundation

struct WebSocketMessage: Codable {
    let topic: String
    let data: String

    func toJSONString() -> String {
        let encoder = JSONEncoder()
        let jsonData = try! encoder.encode(self)
        return String(data: jsonData, encoding: .utf8)!
    }
}
