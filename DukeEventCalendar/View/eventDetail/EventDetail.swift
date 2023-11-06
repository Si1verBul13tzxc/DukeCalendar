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
    @State private var saveToCalendar = false
    @State private var store = EKEventStore()

    var event: Event

    let time = "2023-10-01T04:00:00Z"

    private let ticket: Ticket = Ticket(
        title: "Doing Good Employee Giving Campaign",
        location: "Durham, NC",
        start: "2023-11-1T10:39:32Z",
        end: "2023-11-1T11:58:32Z",
        notes:
            "Doing Good, Duke's annual employee giving campaign, encourages Duke employees to donate to five community-identified need categories, including the United Way of the Greater Triangle. Employees can make tax-deductible donations year-round which create big impacts for community organizations in the region. Learn more or donate at doinggood.duke.edu."
    )

    @State var commentViewVisible = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    Text(event.summary).font(.system(size: 18)).fontWeight(.heavy)  //summary
                    Text(event.status.rawValue).font(.system(size: 10)).foregroundColor(Color.gray)  //status
                    Text("By \(event.sponsor)")  //sponsor?

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
                            EventEditViewController(ticket: self.ticket)
                        }
                    )
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
    EventDetail(event: sample_event)
}

/*
 "id":"CAL-2c918083-7bf1eaed-017c-150f18e4-0000595cdemobedework@mysite.edu_20231001T040000Z",
 "start_timestamp":"2023-10-01T04:00:00Z",
 "end_timestamp":"2024-06-30T04:00:00Z",
 "summary":"Doing Good Employee Giving Campaign",
 "description":"Doing Good, Duke's annual employee giving campaign, encourages Duke employees to donate to five community-identified need categories, including the United Way of the Greater Triangle. Employees can make tax-deductible donations year-round which create big impacts for community organizations in the region. Learn more or donate at doinggood.duke.edu.",
 "status":"CONFIRMED",
 "sponsor":"Office of Durham and Community Affairs",
 "co_sponsors":null,
 "location":{"address":"Durham, NC"},
 "contact":{"name":"Redmond, Domonique","phone":"684-4377"},
 "categories":["Civic Engagement/Social Action",
 "Ongoing","Volunteer/Community Service","Charity/Fundraising","Announcement"],
 "link":"https://calendar.duke.edu/show?fq=id:CAL-2c918083-7bf1eaed-017c-150f18e4-0000595cdemobedework@mysite.edu_20231001T040000Z",
 "event_url":"https://doinggood.duke.edu","submitted_by":["dredmond"],
 "image":"https://calendar.duke.edu/images//2023/20231001/e803641db77b22df79fb6aa807689c32-CR-PARK CHURCH (530 x 353 px)_20211025051033PM.png",
 "image_alt_text":"Doing Good"}
 */
