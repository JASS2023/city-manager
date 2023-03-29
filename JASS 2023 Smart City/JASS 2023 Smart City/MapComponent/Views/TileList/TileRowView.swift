//
//  TileRow.swift
//  JASS 2023 Smart City
//
//  Created by Philipp Zagar on 27.03.23.
//

import Foundation
import SwiftUI

struct TileRowView: View {
    let tile: TileCell

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("i: \(tile.i), j: \(tile.j)")
                    .font(.headline)
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text(tile.type.rawValue.capitalized)
                    .font(.headline)
                Text("Yaw: \(tile.yaw ?? 0, specifier: "%.2f")")
                    .font(.subheadline)
            }
        }
        .padding()
    }
}
