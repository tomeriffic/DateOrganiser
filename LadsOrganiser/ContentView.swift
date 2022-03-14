//
//  ContentView.swift
//  LadsOrganiser
//
//  Created by Tomas Pilvelis on 12/03/2022.
//

import Foundation
import SwiftUI

let APP_NAME = "Organiser"
let DATE_FORMAT = "E dd/MM/yyyy"
let DATE_FORMAT_T = "dd/MM/yyyy HH:mm"

struct LogoArea: View {
    var body: some View {
        HStack {
            Text(APP_NAME)
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

struct ColumnNames: View {
    var body: some View {
        HStack {
            Text("Title")
            Text("Confirmed")
            Text("Attendees")
            Text("Date")
        }
    }
}

struct EventRowEntry: View {
    private var event: Event
    private var df = DateFormatter()
    
    init(){
        df.dateFormat = DATE_FORMAT
        event = Event()
    }
    
    init(event: Event){
        df.dateFormat = DATE_FORMAT
        self.event = event
    }
    
    var body: some View {
        HStack {
            Text(event.title)
            Spacer()
            if event.state == EventState.Confirmed{
                Label("", systemImage: "checkmark.circle").foregroundColor(.green)
                Text(df.string(from: event.selectedDate))
            } else {
                Label("", systemImage: "circle").foregroundColor(.red)
                Text("Awaiting Votes")
            }
        }
    }
}

struct NewEventButton: View {
    @Binding var action: Int?
    var body: some View {
        Button{
            action = 1
        } label:{
            Label("New Event", systemImage: "calendar.badge.plus")
        }
    }
}

struct ContentView: View {
    @State private var action: Int? = 0
    @State private var events: [Event] = [
        Event(
            title: "Chicken",
            state: .Confirmed,
            maxParticipants: 6,
            fromDate: Date(),
            toDate: Date(),
            selectedDate: Date()
        ),
        Event()
    ]
    
    var body: some View {
        NavigationView {
            VStack {
                LogoArea()
                TitleEvents()
                //ColumnNames()
                Form {
                    ForEach(events, id: \.self) { event in
                        EventRowEntry(event: event)
                    }
                    NavigationLink(destination: CreateEventView(), tag: 1, selection: $action) {
                        NewEventButton(action: $action)
                    }
                }
                
            }
        }
    
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
