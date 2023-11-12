//
//  eventDetail.swift
//  New Bee
//
//  Created by Oli 奥利奥 on 10/29/23.
//

import EventKit
import EventKitUI
import SwiftUI

struct EventDetail: View {
    @EnvironmentObject var datamodel: DataModel
    @State private var saveToCalendar = false
    @State private var showCoSponsors = false

    var event: Event
    @ObservedObject var user: User
    @State var commentViewVisible = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    Text(event.summary).font(.system(size: 18)).fontWeight(.heavy)  //summary
                    Text(event.status.rawValue).font(.system(size: 10)).foregroundColor(Color.gray)  //status
                    HStack {
                        Text("By")  //sponsor?
                        NavigationLink(destination: groupDetail(user: user, group: event.sponsor)) {
                            Text(event.sponsor)
                                .underline()
                        }
                        if showCoSponsors {
                            Text(", ")
                        }

                        if event.co_sponsors != nil && !showCoSponsors {
                            Button("+ \(event.co_sponsors!.count)") {
                                showCoSponsors.toggle()
                            }
                        }
                    }
                    VStack(alignment: .leading){
                        if showCoSponsors{
                            ForEach(event.co_sponsors!, id: \.self){ sponsor in
                                HStack(alignment: .bottom){
                                    NavigationLink(destination: groupDetail(user: user, group: sponsor)) {
                                        Text("\(sponsor), ").multilineTextAlignment(.leading)
                                            .underline()
                                    }
                                }
                            }
                            Button("Hide") {
                                showCoSponsors.toggle()
                            }
                        }
                    }

                    Text("")

                    Text(
                        "\(dateToString(time:event.start_timestamp)) to \(dateToString(time:event.end_timestamp))"
                    )
                    HStack {
                        Image(systemName: "mappin")
                            .foregroundColor(.red)
                        Text(event.location.address)
                    }
                    // 　link to map
                    ZStack {
                        RoundedRectangle(cornerRadius: 5)
                            .foregroundColor(Color(CGColor(gray: 0.3, alpha: 0.2)))
                        Text(event.description).font(.system(size: 13))
                    }
                }
                .padding(.horizontal)
                Divider()
                commentList()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        saveToCalendar.toggle()
                    }
                    ) {
                        Label("Add to calendar", systemImage: "calendar.badge.plus")
                            .labelStyle(.iconOnly)
                    }
                    .sheet(
                        isPresented: $saveToCalendar,
                        content: {
                            EventEditViewController(dukeEvent: event)
                        }  //!!!
                    )
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        if user.isInterested(event: event) {
                            self.user.rmInterested(event: event)
                        }
                        else {
                            user.setAsInterested(event: event)
                        }
                    }
                    ) {
                        if user.isInterested(event: event) {
                            Label("Set as interested", systemImage: "star.fill")
                                .labelStyle(.iconOnly)
                        }
                        else {
                            Label("Set as not interested", systemImage: "star")
                                .labelStyle(.iconOnly)
                        }
                    }
                    .tint(user.isInterested(event: event) ? Color.yellow : Color.gray)

                }
                ToolbarItem(placement: .bottomBar) {
                    newComment(commentViewVisible: $commentViewVisible)
                }
            }
            //.navigationBarTitle("Event", displayMode: .inline)
        }
    }
}

#Preview {
    EventDetail(event: sample_event, user: sampleUser).environmentObject(DataModel())
}
