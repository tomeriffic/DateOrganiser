//
//  DateSelectionView.swift
//  LadsOrganiser
//
//  Created by Tomas Pilvelis on 12/03/2022.
//

import SwiftUI
import CoreData

struct SelectorButton: View {
    var state: Int8 = 0
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

struct VoteContext {
    //var date: String = "0/0/0000"
    var yesCount: Int8 = 0
    var maybeCount: Int8 = 0
    var noCount: Int8 = 0
    var isYesShowing: Bool = true
    var isNoShowing: Bool = true
    var isMaybeShowing: Bool = true
    var isYesDisabled: Bool = false
    var isNoDisabled: Bool = false
    var isMaybeDisabled: Bool = false
    
    init(){}
    
    init(vote: UInt8){
        if vote == 0 {
            
        }
        else if vote == 1 {
            isYesShowing = false
            isNoShowing = false
        }
        else if vote == 2 {
            isMaybeShowing = false
            isNoShowing = false
        }
        else if vote == 3 {
            isYesShowing = false
            isMaybeShowing = false
        }
    }
}

struct DateEntry: View {
    var date: String = "0/0/0000"
    var index: UInt8
    @State var ctxt: VoteContext
    var selectionList: MyVotes

    init(date: String, index: UInt8, selectionList: MyVotes){
        self.date = date
        self.index = index
        self.ctxt = VoteContext(vote: selectionList.items[Int(index)])
        self.selectionList = selectionList
    }

    
    var body: some View {
        HStack {
            VStack{
                HStack {
                    Text(date)
                    Spacer()
                    
                }
                HStack {
                    Text("Yes: \(ctxt.yesCount)").font(.footnote)
                    Text("Maybe: \(ctxt.maybeCount)").font(.footnote)
                    Text("No: \(ctxt.noCount)").font(.footnote)
                    Spacer()
                }
                
            }
            if ctxt.isYesShowing {
                Button {} label: {SelectorButton(state:2)} .onTapGesture{
                    ctxt.yesCount += 1
                    ctxt.isMaybeShowing.toggle(); ctxt.isNoShowing.toggle()
                    ctxt.isYesDisabled.toggle()
                    selectionList.update(index: Int(index), value: 2)
                    print(selectionList.items)
                }.disabled(ctxt.isYesDisabled)
            }
            if ctxt.isMaybeShowing {
                Button {} label: {SelectorButton(state:1)} .onTapGesture {
                    ctxt.maybeCount += 1
                    ctxt.isYesShowing.toggle(); ctxt.isNoShowing.toggle()
                    ctxt.isMaybeDisabled.toggle()
                    selectionList.update(index: Int(index), value: 1)
                }.disabled(ctxt.isMaybeDisabled)
            }
            if ctxt.isNoShowing {
                Button {} label: {SelectorButton(state:3)} .onTapGesture {
                    ctxt.noCount += 1
                    ctxt.isYesShowing.toggle(); ctxt.isMaybeShowing.toggle()
                    ctxt.isNoDisabled.toggle()
                    selectionList.update(index: Int(index), value: 3)
                }.disabled(ctxt.isNoDisabled)
            }
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

struct EventBallotView: View {
    @Binding var isBallotPresented: Bool
    private var options: [Date] = []
    private let displayFormat = DateFormatter()
    private var event: Event = Event()
    @ObservedObject var selectionList : MyVotes
    
    @Environment(\.managedObjectContext) var moc
    

    init(event: Event, toggleShowBallot: Binding<Bool>){
        displayFormat.dateFormat = DATE_FORMAT
        self.event = event
        self._isBallotPresented = toggleShowBallot
        if event.isWeekendOnly{
            options = generateDateList(from: event.fromDate, to: event.toDate, isWeekendsOnly: event.isWeekendOnly)
        } else {
            options = generateDateList(from: event.fromDate, to: event.toDate)
        }
        selectionList = MyVotes(values: Array(repeating: UInt8(0), count: options.count))
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
            print(v)
        }
    }

    
    var body: some View {
        VStack {
            TitleVote(title:event.title)
            List {
                ForEach(Array(zip(options, Array(0...selectionList.items.count))), id: \.0){ option in
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
                    if selectionList.takenFromStorage{
                        updateVote(votesList: selectionList)
                    } else {
                        storeVote(votesList: selectionList)
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
