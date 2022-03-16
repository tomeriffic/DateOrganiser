//
//  CreateEventView.swift
//  LadsOrganiser
//
//  Created by Tomas Pilvelis on 12/03/2022.
//

import SwiftUI



struct EventForm: View {
    @Binding var event: Event
    @State private var isValidDates = true

    var body: some View {
        TextField("Title", text: $event.title)
        TextField("Description", text: $event.description)
            VStack{
                DatePicker(
                     "Start Date",
                     selection: $event.fromDate,
                     displayedComponents: [.date]
                 ).onChange(of: event.fromDate){newValue in
                        isValidDates = validateDatesValid(fromDate: newValue, toDate: event.toDate)
                        event.fromDate = newValue
                }
                
                DatePicker(
                     "End Date",
                     selection: $event.toDate,
                     displayedComponents: [.date]
                ).onChange(of: event.toDate){newValue in
                    isValidDates = validateDatesValid(fromDate: event.fromDate, toDate: newValue)
                    event.toDate = newValue
                }
                
                Toggle("Weekend Only Dates?", isOn: $event.isWeekendOnly).toggleStyle(.switch)
            }
        if !isValidDates{
            Label("Dates are not valid", systemImage: "calendar.badge.exclamationmark").foregroundColor(.red)
        }
    }
}

struct CreateEventView: View {
    @Environment(\.managedObjectContext) var moc
    @State private var event: Event = Event()
    @Binding var openClose: Bool
    
    var body: some View {
        VStack {
            TitleCreateNewEvent()
            Form{
                EventForm(event: $event)
                InviteParticipantsForm(selectedContacts: $event.participants)
            }
            HStack{
                Button {
                    openClose.toggle()
                } label: {
                    Text("Cancel")
                }.buttonStyle(.bordered)
                
                Button("Send Invites and Create"){
                    storeEvent(event: event)
                    openClose.toggle()
                    
                }.buttonStyle(.borderedProminent)
            }
            Spacer()
        }
    }
    
    func storeEvent(event: Event){
        let dataStoreEvent = Events(context: moc)
        dataStoreEvent.id = event.id
        dataStoreEvent.title = event.title
        dataStoreEvent.fromDate = event.fromDate
        dataStoreEvent.toDate = event.toDate
        dataStoreEvent.isWeekendOnly = event.isWeekendOnly
        try? moc.save()
    }
}

struct CreateEventView_Previews: PreviewProvider {
    @State static var openClose: Bool = true
    static var previews: some View {
        CreateEventView(openClose: $openClose)
            
    }
}
