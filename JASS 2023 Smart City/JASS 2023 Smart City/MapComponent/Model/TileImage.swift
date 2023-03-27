//
//  TileImage.swift
//  JASS 2023 Smart City
//
//  Created by Philipp Zagar on 27.03.23.
//

import Foundation
import SwiftUI

enum ImageAsset: String, CaseIterable {
    case brush
    case copy
    case cut
    case delete
    case duckie
    case galka
    case galka_r
    case insert
    case new
    case open
    case png
    case rotate
    case save
    case save_as
    case trim
    case undo
    case barrier
    case building
    case bus
    case citizens
    case cone
    case ground_tags
    case house
    case trafficlight
    case tree
    case truck
    case vehicles
    case watchtowers
    case threeWay = "3way"
    case fourWay = "4way"
    case asphalt
    case curve
    case floor
    case grass
    case straight
    case do_not_enter
    case duck_crossing
    case four_way_intersect
    case left_t_intersect
    case no_left_turn
    case no_right_turn
    case oneway_left
    case oneway_right
    case parking
    case pedestrian
    case right_t_intersect
    case stop
    case t_intersection
    case t_light_ahead
    case yield
    
    var image: Image {
        .init("\(rawValue)", bundle: .main)
    }
}
        
