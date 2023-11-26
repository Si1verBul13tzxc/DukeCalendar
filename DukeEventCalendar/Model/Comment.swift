//
//  Comment.swift
//  DukeEventCalendar
//
//  Created by Oli 奥利奥 on 11/14/23.
//

import Foundation

struct Comment:Hashable, Codable {
    let id: UUID
    let upperComment: UUID?
    let eventid: String
    let userid: String
    let content: String
    let time: Date
    
    init(eventid: String, userid: String, content: String, time: Date, upperComment: UUID? = nil) {
        self.id = UUID()
        self.upperComment = upperComment
        self.eventid = eventid
        self.userid = userid
        self.content = content
        self.time = time
    }
}
