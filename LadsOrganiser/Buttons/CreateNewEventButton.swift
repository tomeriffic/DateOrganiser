//
//  CreateNewEventButton.swift
//  LadsOrganiser
//
//  Created by Tomas Pilvelis on 16/03/2022.
//

import Foundation
import SwiftUI

struct CreateNewEventButton: View {
    @Binding var action: Bool
    var body: some View {
        Button{
            action.toggle()
        } label:{
            Label("New Event", systemImage: "calendar.badge.plus")
        }
    }
}
