//
//  ContactView.swift
//  LadsOrganiser
//
//  Created by Tomas Pilvelis on 13/03/2022.
//

import SwiftUI

struct ContactView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var contacts: [ContactInfo]
    @Binding var searchText: String
    @Binding var showCancelButton: Bool
    @Binding var isPresentingContacts: Bool
    @Binding var selectedContacts: [ContactInfo]
    var body: some View {
        // Search view
              HStack {
                HStack {
                   //search bar magnifying glass image
                   Image(systemName: "magnifyingglass").foregroundColor(.secondary)
                            
                   //search bar text field
                   TextField("search", text: self.$searchText, onEditingChanged: { isEditing in
                   self.showCancelButton = true
                   })
                   
                   // x Button
                   Button(action: {
                       self.searchText = ""
                   }) {
                       Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                              .opacity(self.searchText == "" ? 0 : 1)
                      }
            }
             .padding(8)
             .background(Color(.secondarySystemBackground))
             .cornerRadius(8)
                        
              // Cancel Button
              if self.showCancelButton  {
                  Button("Cancel") {
                     //UIApplication.shared.endEditing(true)
                     self.searchText = ""
                     self.showCancelButton = false
                     self.isPresentingContacts = false
               }
             }
           }
            .padding([.leading, .trailing,.top])
        
        List {
            ForEach (self.contacts.filter({ (cont) -> Bool in
                self.searchText.isEmpty ? true :
                    "\(cont)".lowercased().contains(self.searchText.lowercased())
            })) { contact in
                ContactRow(contact: contact).onTapGesture {
                    self.isPresentingContacts = false
                    self.selectedContacts.append(contact)
                    
                }
            }
        }
    }
                
}

/*struct ContactView_Previews: PreviewProvider {
    static var previews: some View {
        ContactView(contacts: $contacts, searchText: $searchText, showCancelButton: $showCancelButton)
    }
}*/
