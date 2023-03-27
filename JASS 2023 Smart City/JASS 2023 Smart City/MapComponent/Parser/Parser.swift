//
//  Parser.swift
//  JASS 2023 Smart City
//
//  Created by Philipp Zagar on 27.03.23.
//

import Foundation
import Yams

// Used to parse the YAML tile data structure to Swift maps
enum Parser {
    private static func parseTilesYAML(_ yaml: String) throws -> [String: Tile] {
        let decoded = try Yams.load(yaml: yaml) as! [String: [String: [String: Any]]]
        var tiles: [String: Tile] = [:]
        
        for (key, value) in decoded["tiles"]! {
            let tile = Tile(
                i: value["i"] as! Int,
                j: value["j"] as! Int,
                type: TileType(rawValue: value["type"] as! String)!
            )
            tiles[key] = tile
        }

        return tiles
    }

    private static func parseFramesYAML(_ yaml: String) throws -> [String: Frame] {
        let decoded = try Yams.load(yaml: yaml) as! [String: [String: [String: Any]]]
        var frames: [String: Frame] = [:]
        
        for (key, value) in decoded["frames"]! {
            let poseData = value["pose"] as! [String: Double]
            let pose = Pose(
                pitch: poseData["pitch"]!,
                roll: poseData["roll"]!,
                x: poseData["x"]!,
                y: poseData["y"]!,
                yaw: poseData["yaw"]!,
                z: poseData["z"]!
            )
            let frame = Frame(pose: pose, relative_to: value["relative_to"] as! String)
            frames[key] = frame
        }
        
        return frames
    }

    private static func combineTilesAndFrames(tiles: inout [String: Tile], frames: [String: Frame]) {
        for (key, frame) in frames {
            tiles[key]?.yaw = frame.pose.yaw
        }
    }
    
    static func parse(tilesYAML: String, framesYAML: String) -> [String: Tile]? {
        guard let tilesUrl = Bundle.main.url(forResource: tilesYAML, withExtension: "yaml"),
              let framesUrl = Bundle.main.url(forResource: framesYAML, withExtension: "yaml"),
              let tilesYAMLContent = try? String(contentsOf: tilesUrl, encoding: .utf8),
              let framesYAMLContent = try? String(contentsOf: framesUrl, encoding: .utf8) else {
            return nil
        }
        
        do {
            var tiles = try parseTilesYAML(tilesYAMLContent)
            let frames = try parseFramesYAML(framesYAMLContent)
            combineTilesAndFrames(tiles: &tiles, frames: frames)
            
            return tiles;
        } catch {
            print("Error parsing YAML data: (error)")
        }
        
        return nil;
    }
}

