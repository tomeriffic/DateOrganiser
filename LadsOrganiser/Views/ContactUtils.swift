//
//  ContactUtils.swift
//  LadsOrganiser
//
//  Created by Tomas Pilvelis on 13/03/2022.
//

import Foundation
import SwiftUI

struct ContactRow: View {
    var contact: ContactInfo
    var body: some View {
        Text("\(contact.firstName) \(contact.lastName)").foregroundColor(.primary)
    }
}
