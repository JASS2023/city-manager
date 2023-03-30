//
//  AddServicePopupView.swift
//  JASS 2023 Smart City
//
//  Created by Philipp Zagar on 30.03.23.
//

import Foundation
import SwiftUI

struct AddServicePopupView: View {
    let selectedCell: LayeredMapCell?
    
    var body: some View {
        if let selectedCell {
            Text("Empty i: \((selectedCell.tileCell) .i), j: \(selectedCell.tileCell.j)")
                .font(.title)
        }
    }
}
