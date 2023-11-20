//
//  ContentView.swift
//  DukeEventCalendar
//
//  Created by xz353 on 10/28/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            MainPageView().tabItem { Label("Events", systemImage: "list.dash") }
            FollowingGroups(user: sampleUser)
                .tabItem { Label("Following", systemImage: "person.3.fill") }
            InterestedEvents(user: sampleUser).tabItem { Label("Interested", systemImage: "star") }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(DataModel())
}
