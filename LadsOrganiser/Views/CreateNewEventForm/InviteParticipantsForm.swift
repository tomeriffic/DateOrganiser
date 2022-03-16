//
//  InviteParticipantsForm.swift
//  LadsOrganiser
//
//  Created by Tomas Pilvelis on 16/03/2022.
//

import Foundation
import SwiftUI
import Contacts

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
