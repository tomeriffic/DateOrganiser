//
//  DateSelectionView.swift
//  LadsOrganiser
//
//  Created by Tomas Pilvelis on 12/03/2022.
//

import SwiftUI

struct Vote {
    var user: String
    var selectedDates: [Date]
}

struct SelectorButton: View {
    var state: Int8 = 0
    var body: some View {
        switch state {
        case 0:
            return Label("", systemImage: "questionmark").foregroundColor(.blue)
        case 1:
            return Label("", systemImage: "hand.thumbsup.fill").foregroundColor(.green)
        case 2:
            return Label("", systemImage: "hand.thumbsdown.fill").foregroundColor(.red)
        default:
            return Label("Error", systemImage: "exclamationmark.icloud").foregroundColor(.red)
        }
    }
}

struct DateEntry: View {
    var date: String = "0/0/0000"
    @State var yesCount: Int8 = 0
    @State var maybeCount: Int8 = 0
    @State var noCount: Int8 = 0
    @State var isYesShowing: Bool = true
    @State var isNoShowing: Bool = true
    @State var isMaybeShowing: Bool = true
    
    var body: some View {
        HStack {
            VStack{
                HStack {
                    Text(date)
                    Spacer()
                    
                }
                HStack {
                    Text("Yes: \(yesCount)").font(.footnote)
                    Text("Maybe: \(maybeCount)").font(.footnote)
                    Text("No: \(noCount)").font(.footnote)
                    Spacer()
                }
                
            }
            if isYesShowing {
                Button {} label: {SelectorButton(state:1)} .onTapGesture {
                    yesCount += 1
                    isMaybeShowing.toggle()
                    isNoShowing.toggle()
                }
            }
            if isMaybeShowing {
                Button {} label: {SelectorButton(state:0)} .onTapGesture {
                    maybeCount += 1
                    isYesShowing.toggle()
                    isNoShowing.toggle()
                }
            }
            if isNoShowing {
                Button {} label: {SelectorButton(state:2)} .onTapGesture {
                    noCount += 1
                    isYesShowing.toggle()
                    isMaybeShowing.toggle()
                }
            }
        }
    }
}

struct DateSelectionView: View {
    var dates: [Date]?
    var body: some View {
        Form {
            DateEntry()
            DateEntry()
            DateEntry()
        
        }
    }
}

struct TitleVote: View {
    var body: some View {
        HStack {
            Text("Vote")
                .padding()
                .font(.title)
            Spacer()
        }
    }
}

struct EventBallotView: View {
    @Binding var isBallotPresented: Bool
    private var options: [Date] = []
    private let displayFormat = DateFormatter()
    private var from: Date = Date()
    private var to: Date = Date()
    
    init(toggleShowBallot: Binding<Bool>){
        displayFormat.dateFormat = DATE_FORMAT
        let formatter = DateFormatter()
        formatter.dateFormat = DATE_FORMAT_T
        from = formatter.date(from: "20/05/2022 15:00") ?? Date.now
        to = formatter.date(from: "23/05/2022 15:00") ?? Date.now
        options = generateDateList(from: from, to: to)
        self._isBallotPresented = toggleShowBallot
    }
    
    init(from: Date, to: Date, toggleShowBallot: Binding<Bool>){
        displayFormat.dateFormat = DATE_FORMAT
        self.from = from
        self.to = to
        options = generateDateList(from: from, to: to)
        self._isBallotPresented = toggleShowBallot
    }
    var body: some View {
        VStack {
            TitleVote()
            List {
                ForEach(options, id: \.self){ option in
                    DateEntry(
                        date: displayFormat.string(from: option),
                        yesCount: 0,
                        maybeCount: 0,
                        noCount: 0
                    )
                }
            }
            Button {
                isBallotPresented.toggle()
            } label: {
                Text("Cancel")
            }
        }
    }
}

struct EventBallotView_Previews: PreviewProvider {
    @State static var isBallotPresented: Bool = true
    static var previews: some View {
        EventBallotView(toggleShowBallot: $isBallotPresented)
    }
}
