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
            if(userid != ""){
                getFollowings()  // update following groups at the beginning
                getInterested()
            }
        }
    }
    @Published var interestedEvents: [String] = []  //event id string
    @Published var followingGroups: [String] = []
    @Published var isLoggedin: Bool = false

    init() {}

    func getInterested() {
        fetchEvents(forUser: self.userid) { res, error in
            if let res = res {
                DispatchQueue.main.async {
                    self.interestedEvents = res
                    print("InterestedEvents updated, count:\(self.interestedEvents.count)")
                }
                return
            }
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }

    func setAsInterested(event: Event) {
        addUserEvent(userName: self.userid, eventid: event.id){res, error in
            if(res == true){
                DispatchQueue.main.async {
                    var tmp = self.interestedEvents
                    tmp.append(event.id)
                    self.interestedEvents = tmp
                }
            }else{
                if let error = error{
                    print(error.localizedDescription)
                }
            }
            
        }
    }

    func rmInterested(event: Event) {
        removeUserEvent(userName: self.userid, eventid: event.id){res, error in
            if(res == true){
                DispatchQueue.main.async {
                    self.interestedEvents = self.interestedEvents.filter({ $0 != event.id })
                }
            }else{
                if let error = error{
                    print(error.localizedDescription)
                }
            }
            
        }
    }
//
//    func isInterested(event: Event) -> Bool {
//        return self.interestedEvents.contains(event.id)
//    }

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
        addUserToGroup(userName: self.userid, groupName: groupName) { res, error in
            if res == true {
                DispatchQueue.main.async {
                    self.followingGroups.append(groupName)
                }
            }
            else {
                if let error = error {
                    print(error.localizedDescription)
                }
            }

        }
    }

    func unfollow(groupName: String) {
        removeUserFromGroup(userName: self.userid, groupName: groupName) { res, error in
            if res == true {
                DispatchQueue.main.async {
                    self.followingGroups = self.followingGroups.filter({ $0 != groupName })
                }
            }
            else {
                if let error = error {
                    print(error.localizedDescription)
                }
            }

        }
    }
}

extension User{
    convenience init(userid: String, interestedEvents: [String], followingGroups: [String]) {
        self.init()
        self.userid = userid
        self.interestedEvents = interestedEvents
        self.followingGroups = followingGroups
    }

    convenience init(userid: String) {
        self.init()
        self.userid = userid
    }
    
    static let sampleUser = User(userid: "Aoli")
    static let sampleUser2 = User(userid: "userid2", interestedEvents: [sample_event.id], followingGroups: ["Duke Chapel"])
}
