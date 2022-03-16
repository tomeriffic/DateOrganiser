//
//  Event.swift
//  LadsOrganiser
//
//  Created by Tomas Pilvelis on 13/03/2022.
//

import Foundation
import SwiftUI

struct Event: Hashable {
    var id              : UUID          = UUID()
    var title           : String        = String()
    var description     : String        = String()
    var state           : EventState    = .Unconfirmed
    var maxParticipants : Int           = 0
    var fromDate        : Date          = Date()
    var toDate          : Date          = Date()
    var isWeekendOnly   : Bool          = false
    var participants    : [ContactInfo] = []
    var votes           : String        = String()
    var options         : [Date]        = []
    // Only when state is confirmed there is a selected date
    var selectedDate    : Date          = Date()
}

