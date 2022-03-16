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

struct ContentView: View {
    @State private var action: Int? = 0
    @State private var isPresentingCreateEvent = false
    @FetchRequest(sortDescriptors: []) var newEvents: FetchedResults<Events>
    @FetchRequest(sortDescriptors: []) var votes: FetchedResults<Votes>
    @Environment(\.managedObjectContext) var moc
    
    var body: some View {
        VStack {
            LogoArea()
            TitleEvents()
            Form {
                ForEach(castEvent(events: newEvents, votes: votes), id: \.self) { event in
                    EventRowEntry(event: event)
                }
                if newEvents.count == 0{
                    Text("You have no events.")
                }
                CreateNewEventButton(action: $isPresentingCreateEvent)
            }
        }
        .fullScreenCover(isPresented: $isPresentingCreateEvent){
            CreateEventView(openClose: $isPresentingCreateEvent)
        }
    }
    
    func castEvent(events: FetchedResults<Events>, votes: FetchedResults<Votes>) -> [Event] {
        var castedEvents: [Event] = []
        
        for e in events {
            var newEvent = Event()
            newEvent.id = e.id!
            newEvent.title = e.title!
            newEvent.fromDate = e.fromDate!
            newEvent.toDate = e.toDate!
            newEvent.isWeekendOnly = e.isWeekendOnly
            
            for v in votes {
                if v.eventId == e.id!{
                    newEvent.votes = v.vote!
                }
            }
            if newEvent.votes.isEmpty {
                newEvent.votes = MyVotes(values: Array(repeating: UInt8(0), count: newEvent.options.count)).toString()
            }
            
            
            if e.isWeekendOnly{
                newEvent.options = generateDateList(from: e.fromDate!, to: e.toDate!, isWeekendsOnly: e.isWeekendOnly)
            } else {
                newEvent.options = generateDateList(from: e.fromDate!, to: e.toDate!)
            }
            
            castedEvents.append(newEvent)
        }
        
        print("Events: \(events.count)")
        print("Votes: \(votes.count)")
        return castedEvents
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
