//
//  EventState.swift
//  LadsOrganiser
//
//  Created by Tomas Pilvelis on 13/03/2022.
//

import Foundation

enum EventState{
    case Unconfirmed
    case InvitesToBeSent
    case InvitesSent
    case AwaitingVotes
    case VotesInDecisionRequired
    case DecisionMade
    case Confirmed
}
