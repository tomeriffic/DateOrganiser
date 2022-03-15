//
//  CreateEventView.swift
//  LadsOrganiser
//
//  Created by Tomas Pilvelis on 12/03/2022.
//

import SwiftUI
import Contacts

struct TitleCreateNewEvent: View {
    var body: some View {
        HStack {
            Text("Create New Event")
                .padding()
                .font(.title)
            Spacer()
        }
    }
}

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

struct InviteParticipantsForm: View {
    @Binding var selectedContacts: [ContactInfo]
    
    @State private var contacts = [ContactInfo.init(firstName: "", lastName: "", phoneNumber: nil)]
    @State private var searchText = ""
    @State private var showCancelButton: Bool = true
    @State private var isPresentingContacts = false
    
    func getContacts() {
        DispatchQueue.main.async {
            self.contacts = FetchContacts().fetchingContacts()
        }
    }
    
    func requestAccess() {
        let store = CNContactStore()
        switch CNContactStore.authorizationStatus(for: .contacts) {
        case .authorized:
            self.getContacts()
            
        case .denied:
            store.requestAccess(for: .contacts) { granted, error in
                if granted {
                    self.getContacts()
                }
            }
        case .restricted, .notDetermined:
            store.requestAccess(for: .contacts) { granted, error in
                if granted {
                    self.getContacts()
                }
            }
        @unknown default:
            print("error")
        }
    }
    var body: some View {
       
        Label("Me", systemImage: "person.crop.circle.fill").foregroundColor(.indigo)
            ForEach(selectedContacts, id: \.self) { contact in
                Label("\(contact.firstName) \(contact.lastName)", systemImage: "person.crop.circle.fill").foregroundColor(randomColor())
            }
            Button {
                self.requestAccess()
                isPresentingContacts.toggle()
            } label: {
                Label("Add Participant", systemImage: "person.badge.plus")
            }

        .fullScreenCover(isPresented: $isPresentingContacts){
            ContactView(
                contacts: $contacts,
                searchText: $searchText,
                showCancelButton: $showCancelButton,
                isPresentingContacts: $isPresentingContacts,
                selectedContacts: $selectedContacts
            )
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
                    StoreEvent(event: event)
                    openClose.toggle()
                    
                }.buttonStyle(.borderedProminent)
            }
            Spacer()
            
        }
    }
    
    func StoreEvent(event: Event){
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
