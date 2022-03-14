//
//  Utils.swift
//  LadsOrganiser
//
//  Created by Tomas Pilvelis on 13/03/2022.
//

import Foundation
import SwiftUI
import Contacts

struct ContactInfo : Identifiable, Hashable{
    var id = UUID()
    var firstName: String
    var lastName: String
    var phoneNumber: CNPhoneNumber?
}

class FetchContacts {
    
    func fetchingContacts() -> [ContactInfo]{
        var contacts = [ContactInfo]()
        let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]
        let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
        do {
            try CNContactStore().enumerateContacts(with: request, usingBlock: { (contact, stopPointer) in
                contacts.append(ContactInfo(firstName: contact.givenName, lastName: contact.familyName, phoneNumber: contact.phoneNumbers.first?.value))
            })
        } catch let error {
            print("Failed", error)
        }
        contacts = contacts.sorted {
            $0.firstName < $1.firstName
        }
        return contacts
    }
    
}


func generateDateList(from: Date, to: Date) -> [Date]{
    var listOfDates: [Date] = []
    
    listOfDates.append(from)
    
    var currDate: Date = from
    while currDate < to {
        currDate = Calendar.current.date(byAdding: .day, value: 1, to: currDate)!
        listOfDates.append(currDate)
    }
    
    return listOfDates
}

func generateDateList(from: Date, to: Date, isWeekendsOnly: Bool) -> [Date]{
    var listOfDates: [Date] = []
    let df = DateFormatter()
    df.dateFormat = "E"
    
    if (df.string(from: from) == "Sat" || df.string(from: from) == "Sun"){
        listOfDates.append(from)
    }
    
    var currDate: Date = from
    while currDate < to {
        currDate = Calendar.current.date(byAdding: .day, value: 1, to: currDate)!
        
        if (df.string(from: currDate) == "Sat" || df.string(from: currDate) == "Sun"){
            listOfDates.append(currDate)
        }
    }
    
    return listOfDates
}

func randomColor() -> Color {
    switch Int.random(in: Range(1...15)){
    case 1:
        return Color.blue
    case 2:
        return Color.brown
    case 3:
        return Color.red
    case 4:
        return Color.green
    case 5:
        return Color.cyan
    case 6:
        return Color.gray
    case 7:
        return Color.pink
    case 8:
        return Color.purple
    case 9:
        return Color.mint
    case 10:
        return Color.orange
    case 11:
        return Color.teal
    case 12:
        return Color.yellow
    case 13:
        return Color.indigo
    default:
        return Color.black
    }
}
