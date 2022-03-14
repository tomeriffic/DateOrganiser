//
//  CreateEventView.swift
//  LadsOrganiser
//
//  Created by Tomas Pilvelis on 12/03/2022.
//

import SwiftUI
import Contacts


func validateDatesValid(fromDate: Date, toDate: Date) -> Bool{
    if fromDate >= toDate {
        print("FAILED")
        return false
    }
    return true
}

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
    @State private var event: Event = Event()

    @State private var isValidDates = true
    //@State private var isWeekendOnly: Bool = false

    var body: some View {
        TextField("Title", text: $event.title)
        TextField("Description", text: $event.description)
            VStack{
                DatePicker(
                     "Start Date",
                     selection: $event.fromDate,
                     displayedComponents: [.date]
                 )
                    .onChange(of: event.fromDate){newValue in
                        isValidDates = validateDatesValid(fromDate: newValue, toDate: event.toDate)
                }
                DatePicker(
                     "End Date",
                     selection: $event.fromDate,
                     displayedComponents: [.date]
                )
                .onChange(of: event.fromDate){newValue in
                    isValidDates = validateDatesValid(fromDate: event.toDate, toDate: newValue)
                    }
                Toggle("Weekend Only Dates?", isOn: $event.isWeekendOnly).toggleStyle(.switch)
            }
        if !isValidDates{
            Label("Dates are not valid", systemImage: "calendar.badge.exclamationmark").foregroundColor(.red)
        }
    }
}

struct InviteParticipantsForm: View {
    @State private var contacts = [ContactInfo.init(firstName: "", lastName: "", phoneNumber: nil)]
    @State private var searchText = ""
    @State private var showCancelButton: Bool = true
    @State private var isPresentingContacts = false
    @State private var selectedContacts: [ContactInfo] = []
    
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
            ContactView(contacts: $contacts, searchText: $searchText, showCancelButton: $showCancelButton, isPresentingContacts: $isPresentingContacts, selectedContacts: $selectedContacts)
            
        }
        
    }
}

struct CreateEventView: View {
    var body: some View {
        VStack {
            TitleCreateNewEvent()
            Form{
                EventForm()
                InviteParticipantsForm()
            }
            Button("Send Invites and Create"){
                
            }
            Spacer()
            
        }
    }
}

struct CreateEventView_Previews: PreviewProvider {
    static var previews: some View {
        CreateEventView()
    }
}
