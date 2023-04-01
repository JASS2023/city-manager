//
//  JASS_2023_Smart_CityApp.swift
//  JASS 2023 Smart City
//
//  Created by Philipp Zagar on 27.03.23.
//

import SwiftUI
import TouchVisualizer

@main
struct JASS_2023_Smart_CityApp: App {
    @StateObject var model: CityModel = .shared
    
    init() {
        var config = Configuration()
        config.color = UIColor(red: 0.678, green: 0.847, blue: 0.932, alpha: 0.8)
        Visualizer.start(config)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(model)
        }
    }
}
