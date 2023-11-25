//
//  ContentView.swift
//  DukeEventCalendar
//
//  Created by xz353 on 10/28/23.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var datamodel: DataModel
    @EnvironmentObject var user:User
    
    var body: some View {
        if user.isLoggedin {
            TabView {
                MainPageView()
                    .tabItem { Label("Events", systemImage: "list.dash") }
                FollowingGroups()
                    .tabItem { Label("Following", systemImage: "person.3.fill") }
                InterestedEvents(user: sampleUser)
                    .tabItem { Label("Interested", systemImage: "star") }
            }
        }
        else {
            LogInPage()
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(DataModel())
        .environmentObject(User())
}
