//
//  TestImages.swift
//  JASS 2023 Smart City
//
//  Created by Philipp Zagar on 27.03.23.
//

import Foundation
import SwiftUI

// Not really needed, just for further exploration
struct TestImagesView: View {
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
                ForEach(TileType.allCases, id: \.self) { asset in
                    asset.image
                        .resizable()
                        .scaledToFit()
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
                        .shadow(radius: 4)
                    }
                }
            .padding()
        }
    }
}
