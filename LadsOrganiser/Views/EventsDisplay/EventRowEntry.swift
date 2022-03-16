//
//  EventRowEntry.swift
//  LadsOrganiser
//
//  Created by Tomas Pilvelis on 16/03/2022.
//

import Foundation
import SwiftUI

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
                print("DELETING VOTE")
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
