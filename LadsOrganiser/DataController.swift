//
//  DataController.swift
//  LadsOrganiser
//
//  Created by Tomas Pilvelis on 14/03/2022.
//

import Foundation
import CoreData


class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "LocalStore")
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
    }
}
