//
//  DateSelectionView.swift
//  LadsOrganiser
//
//  Created by Tomas Pilvelis on 12/03/2022.
//

import SwiftUI

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
    
}

struct DateEntry: View {
    var date: String = "0/0/0000"
    @State var ctxt: VoteContext = VoteContext()
    
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
                }.disabled(ctxt.isYesDisabled)
            }
            if ctxt.isMaybeShowing {
                Button {} label: {SelectorButton(state:1)} .onTapGesture {
                    ctxt.maybeCount += 1
                    ctxt.isYesShowing.toggle(); ctxt.isNoShowing.toggle()
                    ctxt.isMaybeDisabled.toggle()
                }.disabled(ctxt.isMaybeDisabled)
            }
            if ctxt.isNoShowing {
                Button {} label: {SelectorButton(state:3)} .onTapGesture {
                    ctxt.noCount += 1
                    ctxt.isYesShowing.toggle(); ctxt.isMaybeShowing.toggle()
                    ctxt.isNoDisabled.toggle()
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
    @State private var selectionList: [UInt8] = []
    @FetchRequest(sortDescriptors: []) var votes: FetchedResults<Votes>
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
        let initArray = Array(repeating: UInt8(0), count: options.count)
        print(initArray)
        selectionList.append(contentsOf: initArray)
        print(".")
        //selectionList = Array(repeating: UInt8(0), count: options.count)
        print(selectionList)
    }
    
    func StoreVote(){
        let dataStoreEvent = Votes(context: moc)
        dataStoreEvent.id = UUID()
        dataStoreEvent.eventId = event.id

        try? moc.save()
    }
    
    var body: some View {
        VStack {
            TitleVote(title:event.title)
            List {
                ForEach(options, id: \.self){ option in
                    DateEntry(date: displayFormat.string(from: option))
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
                    StoreVote()
                } label: {
                    Text("Submit")
                }.buttonStyle(.borderedProminent)
                Spacer()
            }
        }
    }
}

struct EventBallotView_Previews: PreviewProvider {
    @State static var isBallotPresented: Bool = true
    static var event: Event = Event()
    static var previews: some View {
        EventBallotView(event: event, toggleShowBallot: $isBallotPresented)
    }
}
