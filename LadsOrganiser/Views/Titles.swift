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

struct TitleVote: View {
    var title: String = String()
    var body: some View {
        VStack{
            HStack {
                Text("Vote")
                    .font(.title)
                Spacer()
            }
            HStack {
                Text(title)
                    .font(.title3)
                Spacer()
            }
        }.padding()
    }
}
