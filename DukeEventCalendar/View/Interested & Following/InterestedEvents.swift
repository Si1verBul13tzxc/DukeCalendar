//
//  InterestedEvents.swift
//  DukeEventCalendar
//
//  Created by Oli 奥利奥 on 11/8/23.
//

import SwiftUI

struct InterestedEvents: View {
    @EnvironmentObject var datamodel:DataModel
    @ObservedObject var user: User
    
    var body: some View {
        NavigationView{
            List{
                ForEach(user.getInterested(), id: \.self){ id in
                    if let event = datamodel.getEvent(eventid: id) {
                        NavigationLink(destination: EventDetail(event: event, user: user)) {
                            EventRowView(event: event)
                        }

                    }
                                    }
            }
            .navigationTitle("Interested")
        }
    }
}

#Preview {
    InterestedEvents(user: sampleUser2).environmentObject(DataModel())
}
