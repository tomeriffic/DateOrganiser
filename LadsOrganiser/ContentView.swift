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

struct EventRowEntry: View {
    private var event: Event
    private var df = DateFormatter()
    @State private var isPresentingVoteView: Bool = false
    @FetchRequest(sortDescriptors: []) var newEvents: FetchedResults<Events>
    @FetchRequest(sortDescriptors: []) var votes: FetchedResults<Votes>
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
        
        
        for (v, element) in votes.enumerated() {
            if id == element.eventId{
                let vote = votes[v]
                moc.delete(vote)
                try? moc.save()
                print("DELETEING VOTE")
            }
        }
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
            
            castedEvents.append(newEvent)
        }
        
        print("\(events.count)")
        print("Votes: \(votes.count)")
        return castedEvents
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
