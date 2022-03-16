//
//  DateEntry.swift
//  LadsOrganiser
//
//  Created by Tomas Pilvelis on 16/03/2022.
//

import Foundation
import SwiftUI

struct DateEntry: View {
    var date: String = "0/0/0000"
    var index: UInt8
    @State var ctxt: VoteViewContext
    var selectionList: MyVotes

    init(date: String, index: UInt8, selectionList: MyVotes){
        self.date = date
        self.index = index
        self.ctxt = VoteViewContext(vote: selectionList.items[Int(index)])
        self.selectionList = selectionList
    }

    
    var body: some View {
        HStack {
            VStack{
                HStack {
                    Text(date)
                    Spacer()
                    
                }
                HStack {
                    Text("Yes: \(ctxt.yesCount)").font(.footnote)
                    Text("Maybe: \(ctxt.maybeCount)").font(.footnote)
                    Text("No: \(ctxt.noCount)").font(.footnote)
                    Spacer()
                }
                
            }
            if ctxt.isYesShowing {
                Button {} label: {VoteSelectorButton(state:VoteEnum.Yes.rawValue)} .onTapGesture{
                    ctxt.yesCount += 1
                    ctxt.isMaybeShowing.toggle(); ctxt.isNoShowing.toggle()
                    ctxt.isYesDisabled.toggle()
                    selectionList.update(index: Int(index), value: 2)
                    print(selectionList.items)
                }.disabled(ctxt.isYesDisabled)
            }
            if ctxt.isMaybeShowing {
                Button {} label: {VoteSelectorButton(state: VoteEnum.Maybe.rawValue)} .onTapGesture {
                    ctxt.maybeCount += 1
                    ctxt.isYesShowing.toggle(); ctxt.isNoShowing.toggle()
                    ctxt.isMaybeDisabled.toggle()
                    selectionList.update(index: Int(index), value: 1)
                }.disabled(ctxt.isMaybeDisabled)
            }
            if ctxt.isNoShowing {
                Button {} label: {VoteSelectorButton(state: VoteEnum.No.rawValue)} .onTapGesture {
                    ctxt.noCount += 1
                    ctxt.isYesShowing.toggle(); ctxt.isMaybeShowing.toggle()
                    ctxt.isNoDisabled.toggle()
                    selectionList.update(index: Int(index), value: 3)
                }.disabled(ctxt.isNoDisabled)
            }
        }
    }
}
