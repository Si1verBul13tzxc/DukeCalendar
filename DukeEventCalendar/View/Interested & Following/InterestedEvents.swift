//
//  InterestedEvents.swift
//  DukeEventCalendar
//
//  Created by Oli 奥利奥 on 11/8/23.
//

import SwiftUI

enum EventPicker: String, CaseIterable {
    case future = "Future"
    case past = "Past"
}

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
                EventCarouselView(data: user.interestedEvents)
            }
            .navigationTitle("Interested Events")
            .navigationBarTitleDisplayMode(.inline)
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
