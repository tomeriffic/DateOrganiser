//
//  SelectorButton.swift
//  LadsOrganiser
//
//  Created by Tomas Pilvelis on 16/03/2022.
//

import Foundation
import SwiftUI

struct VoteSelectorButton: View {
    var state: UInt8 = 0
    var body: some View {
        switch state {
        case 1:
            return Label("", systemImage: "questionmark").foregroundColor(.blue)
        case 2:
            return Label("", systemImage: "hand.thumbsup.fill").foregroundColor(.green)
        case 3:
            return Label("", systemImage: "hand.thumbsdown.fill").foregroundColor(.red)
        default:
            return Label("Error", systemImage: "exclamationmark.icloud").foregroundColor(.red)
        }
    }
}
