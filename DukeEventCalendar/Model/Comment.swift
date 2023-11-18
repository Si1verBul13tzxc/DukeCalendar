//
//  Comment.swift
//  DukeEventCalendar
//
//  Created by Oli 奥利奥 on 11/14/23.
//

import Foundation

struct Comment:Hashable {
    let id = UUID()
    let eventid: String
    let userid: String
    let content: String
    let time: Date
}
