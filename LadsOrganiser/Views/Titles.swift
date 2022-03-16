//
//  Titles.swift
//  LadsOrganiser
//
//  Created by Tomas Pilvelis on 16/03/2022.
//

import Foundation
import SwiftUI

struct TitleCreateNewEvent: View {
    var body: some View {
        HStack {
            Text("Create New Event")
                .padding()
                .font(.title)
            Spacer()
        }
    }
}

struct TitleEvents: View {
    var body: some View {
        HStack {
            Text("Events")
                .font(.title2)
                .padding()
            Spacer()
        }
    }
}
