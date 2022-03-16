//
//  VoteContext.swift
//  LadsOrganiser
//
//  Created by Tomas Pilvelis on 16/03/2022.
//

import Foundation


struct VoteViewContext {
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
        if vote == VoteEnum.NoSelectedOption.rawValue {
            // Signifies No Vote Selected
        }
        else if vote == VoteEnum.Maybe.rawValue {
            maybeCount += 1
            isYesShowing = false
            isNoShowing = false
        }
        else if vote == VoteEnum.Yes.rawValue {
            yesCount += 1
            isMaybeShowing = false
            isNoShowing = false
        }
        else if vote == VoteEnum.No.rawValue {
            noCount += 1
            isYesShowing = false
            isMaybeShowing = false
        }
    }
}
