//
//  CityModel.swift
//  JASS 2023 Smart City
//
//  Created by Philipp Zagar on 27.03.23.
//

import Foundation

class CityModel: ObservableObject {
    static var shared = CityModel()
    
    @Published var tiles: [String : TileCell] = [:]
}
