//
//  DukeEventCalendarApp.swift
//  DukeEventCalendar
//
//  Created by xz353 on 10/28/23.
//

import SwiftUI

@main
struct DukeEventCalendarApp: App {
    @StateObject var datamodel:DataModel = DataModel()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(datamodel)
        }
    }
}
