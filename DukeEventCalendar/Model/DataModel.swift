//
//  DataModel.swift
//  DukeEventCalendar
//
//  Created by xz353 on 11/2/23.
//

import Foundation

class DataModel: ObservableObject {
    @Published var futureDays: Double = 1.0
    typealias EventFilter = (Event) -> Bool

    init() {
        self.EventFilters.append(futureDaysFilter)
    }

    var filteredEvents: [Event] {
        guard var events = DataModel.sampleEvents else { return [] }
        for filter in EventFilters {
            events = events.filter(filter)
        }
        print(events.count)
        return events
    }

    var EventFilters: [EventFilter] = []

    func futureDaysFilter(event: Event) -> Bool {
        if event.start_timestamp
            <= Date(
                timeIntervalSinceNow: futureDays * 24 * 3600
            ) && event.end_timestamp > Date.now
        {
            print("include in \(futureDays)")
            return true
        }
        print("not include in \(futureDays)")
        return false
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
        guard var events = DataModel.sampleEvents else { return [] }
        events = events.filter({$0.sponsor == groupName || (($0.co_sponsors?.contains(groupName)) != nil)})
        return events
    }
    func getEvent(eventid: String) -> Event? {
        guard var events = DataModel.sampleEvents else { return nil }
        events = events.filter({$0.id == eventid})
        return events[0]
    }
}
