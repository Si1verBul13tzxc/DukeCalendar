//
//  User.swift
//  DukeEventCalendar
//
//  Created by Oli 奥利奥 on 11/8/23.
//

import Foundation

class User: ObservableObject {
    let userid: String
    @Published var interestedEvents: [String] //event id string
    @Published var followingGroups: [String]
    
    init(userid: String, interestedEvents: [String], followingGroups: [String]) {
        self.userid = userid
        self.interestedEvents = interestedEvents
        self.followingGroups = followingGroups
    }
    
    init(userid: String) {
        self.userid = userid
        self.interestedEvents = []
        self.followingGroups = []
    }
    
    func getInterested() -> [String] {
        return self.interestedEvents
    }
    
    func setAsInterested(event:Event) {
        self.interestedEvents.append(event.id)
    }
    
    func rmInterested(event:Event) {
        self.interestedEvents = self.interestedEvents.filter({$0 != event.id})
    }
    
    func isInterested(event: Event) -> Bool {
        return self.interestedEvents.contains(event.id)
    }
    
    func getFollowings() -> [String] {
        return self.followingGroups
    }
    
    func follow(groupName: String) {
        self.followingGroups.append(groupName)
    }
    
    func unfollow(groupName: String) {
        self.followingGroups = self.followingGroups.filter({$0 != groupName})
    }
    
    func isFollowing(groupName: String) -> Bool {
        return self.followingGroups.contains(groupName)
    }
}
