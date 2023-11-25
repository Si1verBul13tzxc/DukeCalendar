//
//  InterestedEvents.swift
//  DukeEventCalendar
//
//  Created by Oli 奥利奥 on 11/8/23.
//

import SwiftUI

struct InterestedEvents: View {
    @EnvironmentObject var datamodel: DataModel
    @EnvironmentObject var user: User

    var body: some View {
        NavigationView {
            List {
                ForEach(user.interestedEvents, id: \.self) { id in
                    if let event = datamodel.getEvent(eventid: id) {
                        NavigationLink(destination: EventDetail(event: event)) {
                            EventRowView(event: event)
                        }

                    }
                }
            }
            .navigationTitle("Interested")
        }
        .onAppear{
            user.getInterested()
        }
    }
}

#Preview {
    InterestedEvents()
        .environmentObject(DataModel())
        .environmentObject(User())
}
