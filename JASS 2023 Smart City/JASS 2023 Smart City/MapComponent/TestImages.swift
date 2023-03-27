//
//  TestImages.swift
//  JASS 2023 Smart City
//
//  Created by Philipp Zagar on 27.03.23.
//

import Foundation
import SwiftUI

struct TestImages: View {
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
                ForEach(ImageAsset.allCases, id: \.self) { asset in
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
