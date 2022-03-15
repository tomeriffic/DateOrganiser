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
    @State private var isPresentingVoteView: Bool = false
    @FetchRequest(sortDescriptors: []) var newEvents: FetchedResults<Events>
    @Environment(\.managedObjectContext) var moc
    
    init(){
        df.dateFormat = DATE_FORMAT
        event = Event()
    }
    
    init(event: Event){
        df.dateFormat = DATE_FORMAT
        self.event = event
    }
    
    func deleteEventRow(id: UUID){
        var index = -1
        for (i, element) in newEvents.enumerated() {
            print("Item \(i): \(element.id)")
            if id == element.id {
                index = i
            }
        }
        
        let user = newEvents[index]
        moc.delete(user)
        try? moc.save()
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
            Menu("..."){
                Button{
                    isPresentingVoteView.toggle()
                }label: {
                    Label("Vote", systemImage: "square.and.pencil").foregroundColor(.black)
                }
                Button{
                    deleteEventRow(id: event.id)
                }label: {
                    Label("Delete", systemImage: "trash").foregroundColor(.red)
                }
            }
        }
        .fullScreenCover(isPresented: $isPresentingVoteView){
            EventBallotView(event: event, toggleShowBallot: $isPresentingVoteView)
        }
    }
}

struct NewEventButton: View {
    @Binding var action: Bool
    var body: some View {
        Button{
            action.toggle()
        } label:{
            Label("New Event", systemImage: "calendar.badge.plus")
        }
    }
}

struct ContentView: View {
    @State private var action: Int? = 0
    @State private var isPresentingCreateEvent = false
    @FetchRequest(sortDescriptors: []) var newEvents: FetchedResults<Events>
    @Environment(\.managedObjectContext) var moc
    
    var body: some View {
        VStack {
            LogoArea()
            TitleEvents()
            //ColumnNames()
            Form {
                ForEach(castEvent(events: newEvents), id: \.self) { event in
                    EventRowEntry(event: event)
                }
                if newEvents.count == 0{
                    Text("You have no events.")
                }
                NewEventButton(action: $isPresentingCreateEvent)
            }
        }
        .fullScreenCover(isPresented: $isPresentingCreateEvent){
            CreateEventView(openClose: $isPresentingCreateEvent)
        }
    }
    
    func castEvent(events: FetchedResults<Events>) -> [Event] {
        var castedEvents: [Event] = []
        for e in events{
            var newEvent = Event()
            newEvent.id = e.id!
            newEvent.title = e.title!
            castedEvents.append(newEvent)
        }
        
        print("\(events.count)")
        return castedEvents
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
