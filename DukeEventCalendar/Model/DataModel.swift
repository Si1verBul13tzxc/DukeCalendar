//
//  DataModel.swift
//  DukeEventCalendar
//
//  Created by xz353 on 11/2/23.
//

import Foundation

class DataModel: ObservableObject {
    typealias EventFilter = (Event) -> Bool
    @Published var futureDays: Double
    @Published var dukeEvents: [Event]?
    @Published var excludeOngoing: Bool = false
    @Published var comments: [Comment]?
    @Published var savedCateTags = TagRows()
    @Published var savedGroupTags = TagRows()
    @Published var isLoading = false
    
    var EventFilters: [EventFilter] {
        var filters: [EventFilter] = []
        filters.append(futureDaysFilter)
        if excludeOngoing {
            filters.append(notOnGoingFilter)
        }
        return filters
    }

    var filteredEvents: [Event] {
        guard var events = self.dukeEvents else { return [] }
        for filter in EventFilters {
            events = events.filter(filter)
        }
        print("Filtered Events' count: \(events.count)")
        return events
    }

    init() {
        self.futureDays = 1.0
        generateAndFetchEvents(groups: nil, categories: nil, futureDays: 30, dataModel: self)
        isLoading = true
    }

    func updateEvents() {
        let groups: [String] = savedGroupTags.tags.map { $0.name }
        let categories: [String] = savedCateTags.tags.map { $0.name }
        generateAndFetchEvents(
            groups: groups,
            categories: categories,
            futureDays: 30,
            dataModel: self
        )
        isLoading = true
    }

    func loadEvents() {
        //load data from events.json
        do {
            let tmpEvents: [String: [Event]] = try load("events.json")
            self.dukeEvents = tmpEvents["events"]
        }
        catch {
            print(error.localizedDescription)
        }
    }

    func futureDaysFilter(event: Event) -> Bool {
        if event.start_timestamp
            <= Date(
                timeIntervalSinceNow: futureDays * 24 * 3600
            ) && event.end_timestamp > Date.now
        {
            return true
        }
        return false
    }

    //exclude the event if it already starts
    func notOnGoingFilter(event: Event) -> Bool {
        if event.start_timestamp < Date.now {
            return false
        }
        return true
    }

    static let sampleEvents: [Event]? = getSampleEvents()
    static func getSampleEvents() -> [Event]? {
        let url = Bundle.main.url(forResource: "sample_5", withExtension: "json")
        do {
            let data = try Data(contentsOf: url!)
            let decoder = JSONDecoder()
            let events = try decoder.decode([String: [Event]].self, from: data)
            let events_list = events["events"]
            return events_list
        }
        catch let error as NSError {
            print(error)
            return nil
        }
    }

    func getGroupEvents(groupName: String) -> [Event] {
        guard var events = self.dukeEvents else { return [] }
        events = events.filter({
            $0.sponsor == groupName
                || (($0.co_sponsors != nil) && ($0.co_sponsors!.contains(groupName)))
        })
        return events
    }

    func getEvent(eventid: String) -> Event? {
        guard var events = self.dukeEvents else { return nil }
        events = events.filter({ $0.id == eventid })
        return events[0]
    }
    
    func addComment(comment: Comment) -> Bool {
        if self.comments == nil {
            self.comments = [comment]
        }
        else {
            self.comments!.append(comment)
        }
        return findComment(cmtid: comment.id)
    }

    func getComments(eventid: String) -> [Comment] {
        if self.comments == nil {
            return []
        }
        else {
            return self.comments!.filter({ $0.eventid == eventid })
        }
    }

    func findComment(cmtid: UUID) -> Bool {
        return self.comments?.filter({ $0.id == cmtid }) != nil
    }
    
    
    func deleteComment(cmtid: UUID) {
        self.comments = self.comments?.filter({($0.id != cmtid)&&($0.upperComment != cmtid)})
//        if findComment(cmtid: cmtid){
//            self.comments = self.comments?.filter({$0.id != cmtid})
//        }
//        else {
//            return
//        }
    }
    
    func getSubComments(cmtid: UUID) -> [Comment] {
        if self.findComment(cmtid: cmtid) {
            return self.comments!.filter({$0.upperComment == cmtid})
        }
        return []
    }
    
    func getMainComments() -> [Comment] {
        if self.comments != nil {
            return self.comments!.filter({$0.upperComment == nil})
        }
        return []
    }
}
