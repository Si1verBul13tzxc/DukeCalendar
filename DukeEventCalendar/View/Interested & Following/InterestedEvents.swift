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
    @State private var pickerType = EventPicker.future
    @State var eventPicked: Event?

    var body: some View {
        NavigationView {

            VStack {
                Picker("", selection: $pickerType) {
                    ForEach(EventPicker.allCases, id: \.rawValue) {
                        Text($0.rawValue).tag($0)
                    }
                }
                .pickerStyle(.segmented)
                .padding()
                Spacer()

                if let event = eventPicked {
                    NavigationLink(destination: EventDetail(event: event)) {
                        EventCard(event: event)
                    }
                }

                GeometryReader { g in
                    let size = g.size
                    let padding = (size.width - 70) / 2

                    ScrollView(.horizontal) {
                        HStack(spacing: 35) {
                            ForEach(user.interestedEvents, id: \.self) { id in
                                if let event = datamodel.getEvent(eventid: id) {
                                    EventCardImage(imgURL: event.image)
                                        .onTapGesture {
                                            eventPicked = event
                                        }
                                }
                            }
                        }
                        .scrollTargetLayout()
                    }
                    .safeAreaPadding(.horizontal, padding)
                    .scrollIndicators(.hidden)
                    .scrollTargetBehavior(.viewAligned)
                    .frame(height: size.height)
                }
                .frame(height: 130)
            }
            .navigationTitle("Interested")
            .navigationBarTitleDisplayMode(.automatic)
        }
        .onAppear {
            user.getInterested()
            if let id = user.interestedEvents.first {
                eventPicked = datamodel.getEvent(eventid: id)
            }
        }
        .onChange(of: user.interestedEvents) {
            if user.interestedEvents.isEmpty {
                eventPicked = nil
            }
            if user.interestedEvents.count == 1 {
                if let id = user.interestedEvents.first {
                    eventPicked = datamodel.getEvent(eventid: id)
                }
            }
        }
    }
}

#Preview {
    InterestedEvents()
        .environmentObject(DataModel())
        .environmentObject(User())
}

enum EventPicker: String, CaseIterable {
    case future = "Future"
    case past = "Past"
}
