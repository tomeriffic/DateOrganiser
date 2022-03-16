//
//  DateSelectionView.swift
//  LadsOrganiser
//
//  Created by Tomas Pilvelis on 12/03/2022.
//

import SwiftUI
import CoreData

struct EventBallotView: View {
    @Binding var isBallotPresented: Bool
    private let displayFormat = DateFormatter()
    private var event: Event = Event()
    @ObservedObject var selectionList : MyVotes
    @Environment(\.managedObjectContext) var moc
    
    init(event: Event, toggleShowBallot: Binding<Bool>){
        displayFormat.dateFormat = DATE_FORMAT
        self.event = event
        self._isBallotPresented = toggleShowBallot
        
        selectionList = MyVotes()
        selectionList.fromString(votes: event.votes)
    }
    
    func storeVote(votesList: MyVotes){
        let dataStoreEvent = Votes(context: moc)
        dataStoreEvent.id = UUID()
        dataStoreEvent.eventId = event.id
        dataStoreEvent.vote = votesList.toString()
        try? moc.save()
    }
    
    func updateVote(votesList: MyVotes) {
        let votes = try? moc.fetch(NSFetchRequest<NSFetchRequestResult>(entityName: "Votes")) as? [NSManagedObject]
        for v in votes! {
            if event.id == v.value(forKey: "eventId") as? UUID{
                v.setValue(votesList.toString(), forKey: "vote")
                print("UPDATING")
                try? moc.save()
            }
        }
    }

    var body: some View {
        VStack {
            TitleVote(title:event.title)
            List {
                ForEach(Array(zip(event.options, Array(0...selectionList.items.count))), id: \.0){ option in
                    DateEntry(
                        date: displayFormat.string(from: option.0),
                        index: UInt8(option.1),
                        selectionList: selectionList
                    )
                }
            }
            
            HStack {
                Spacer()
                Button {
                    isBallotPresented.toggle()
                } label: {
                    Text("Cancel")
                }.buttonStyle(.bordered)
                Spacer()
                Button {
                    isBallotPresented.toggle()
                    if selectionList.takenFromStorage{ //If it's taken from storage it just needs updating, not storing again
                        updateVote(votesList: selectionList)
                    } else {
                        if selectionList.hasPendingChanges(){
                            storeVote(votesList: selectionList)
                        }
                    }
                } label: {
                    Text("Submit")
                }.buttonStyle(.borderedProminent)
                Spacer()
            }
        }.onAppear(perform: {
            
        })
    }
}

struct EventBallotView_Previews: PreviewProvider {
    @State static var isBallotPresented: Bool = true
    static var event: Event = Event()
    static var previews: some View {
        EventBallotView(event: event, toggleShowBallot: $isBallotPresented)
    }
}
