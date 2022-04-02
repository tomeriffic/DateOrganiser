//
//  MyVotes.swift
//  LadsOrganiser
//
//  Created by Tomas Pilvelis on 16/03/2022.
//

import Foundation

class MyVotes: ObservableObject {
    @Published var items = [UInt8]()
    var takenFromStorage: Bool = false

    init(){}
    
    init(values: [UInt8]) {
        items = values
    }
    
    func hasPendingChanges() -> Bool{
        for i in items{
            if i > 0 && i < 4{
                return true
            }
        }
        return false
    }
    
    func update(index: Int, value: UInt8){
        items[index] = value
    }
    
    func toString() -> String{
        return items.description
            .trimmingCharacters(in: CharacterSet(charactersIn: "[]")).replacingOccurrences(of: " ", with: "")
    }
    
    func strToIntMap(str: String) -> UInt8 {
        switch (str.trimmingCharacters(in: .whitespaces)){
        case "0":
            return 0
        case "1":
            return 1
        case "2":
            return 2
        case "3":
            return 3
        default:
            return UInt8.max
        }
    }
    
    func fromString(votes: String){
        if votes.contains("1") || votes.contains("2") || votes.contains("3") {
            takenFromStorage = true
        }
        let sArray = votes
                      .trimmingCharacters(in: CharacterSet(charactersIn: "[ ]"))
                      .components(separatedBy:",").map({strToIntMap(str: $0)})
        
        items = sArray
    }
}
