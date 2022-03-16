//
//  VoteContext.swift
//  LadsOrganiser
//
//  Created by Tomas Pilvelis on 16/03/2022.
//

import Foundation


struct VoteContext {
    var yesCount: Int8 = 0
    var maybeCount: Int8 = 0
    var noCount: Int8 = 0
    var isYesShowing: Bool = true
    var isNoShowing: Bool = true
    var isMaybeShowing: Bool = true
    var isYesDisabled: Bool = false
    var isNoDisabled: Bool = false
    var isMaybeDisabled: Bool = false
    
    init(){}
    
    init(vote: UInt8){
        if vote == 0 {
            // Signifies No Vote Selected
        }
        else if vote == 1 {
            isYesShowing = false
            isNoShowing = false
        }
        else if vote == 2 {
            isMaybeShowing = false
            isNoShowing = false
        }
        else if vote == 3 {
            isYesShowing = false
            isMaybeShowing = false
        }
    }
}
