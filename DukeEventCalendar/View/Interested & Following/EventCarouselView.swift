//
//  EventCarouselView.swift
//  DukeEventCalendar
//
//  Created by xz353 on 11/28/23.
//

import SwiftUI

struct EventCarouselView: View {
    @EnvironmentObject var datamodel: DataModel
    let testCards = [
        DataModel.sampleEvents![0], DataModel.sampleEvents![1], DataModel.sampleEvents![2],
    ]  // data for preview
    let data: [String]
    @State private var activePageID: String?  //Event's id is string type

    var body: some View {
        VStack {
            ScrollView(.horizontal) {
                LazyHStack {
                    ForEach(data, id: \.self) { event_id in
                        if let event = datamodel.getEvent(eventid: event_id) {
                            NavigationLink {
                                EventDetail(event: event)
                            } label: {
                                EventCard(event: event)
                                    .containerRelativeFrame(.horizontal)
                                    .scrollTransition(axis: .horizontal) { content, phase in
                                        content
                                            .scaleEffect(
                                                x: phase.isIdentity ? 1.2 : 0.8,
                                                y: phase.isIdentity ? 1.2 : 0.8
                                            )
                                            .rotation3DEffect(
                                                .degrees(phase.value * 30.0),
                                                axis: (x: 0, y: 1, z: 0)
                                            )
                                    }
                            }
                        }
                    }
                }
                .scrollTargetLayout()  // allow the ScrollView to understand where to find the identifiers for the binding
            }
            .scrollIndicators(.hidden)
            .scrollPosition(id: $activePageID)
            Spacer()
            ImagePagingControl(data:data, activePageID: activePageID)
                .offset(y: -50)
        }
    }
}

#Preview {
    EventCarouselView(data:[])
        .environmentObject(DataModel())
}
