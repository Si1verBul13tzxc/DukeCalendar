//
//  User.swift
//  DukeEventCalendar
//
//  Created by Oli 奥利奥 on 11/8/23.
//

import Foundation

class User: ObservableObject {
    var userid: String = "" {
        didSet {
            getFollowings() // update following groups at the beginning
        }
    }
    @Published var interestedEvents: [String] = []  //event id string
    @Published var followingGroups: [String] = []
    @Published var isLoggedin: Bool = false

    init() {}

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

    func setAsInterested(event: Event) {
        self.interestedEvents.append(event.id)
    }

    func rmInterested(event: Event) {
        self.interestedEvents = self.interestedEvents.filter({ $0 != event.id })
    }

    func isInterested(event: Event) -> Bool {
        return self.interestedEvents.contains(event.id)
    }

    func getFollowings() {
        fetchGroups(forUser: self.userid) { result, error in
            if let res = result {
                DispatchQueue.main.async {
                    self.followingGroups = res
                    print("followingGroups updated, count:\(self.followingGroups.count)")
                }
            }
            else {
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
    }

    func follow(groupName: String) {
        //self.followingGroups.append(groupName)
        addUserToGroup(userName: self.userid, groupName: groupName) { res, error in
            if res == true {
                DispatchQueue.main.async {
                    self.followingGroups.append(groupName)
                }
                //getFollowings?
            }
            else {
                if let error = error {
                    print(error.localizedDescription)
                }
            }

        }
    }

    func unfollow(groupName: String) {
        //self.followingGroups = self.followingGroups.filter({ $0 != groupName })
        removeUserFromGroup(userName: self.userid, groupName: groupName) { res, error in
            if res == true {
                DispatchQueue.main.async {
                    self.followingGroups = self.followingGroups.filter({ $0 != groupName })
                }
                //getFollowings?
            }
            else {
                if let error = error {
                    print(error.localizedDescription)
                }
            }

        }
    }

    //    func isFollowing(groupName: String) -> Bool {
    //        return self.followingGroups.contains(groupName)
    //    }
}
