//
//  MainPageView.swift
//  DukeEventCalendar
//
//  Created by xz353 on 11/6/23.
//

import SwiftUI

struct MainPageView: View {
    @EnvironmentObject var datamodel: DataModel
    var body: some View {
        NavigationStack {
            if datamodel.filteredEvents.isEmpty {
                VStack {
                    Text("One moment...")
                    ProgressView()
                        .navigationTitle("Events")
                }
            }
            else {
                List {
                    ForEach(datamodel.filteredEvents, id: \.id) { event in
                        NavigationLink {
                            EventDetail(event: event, user: sampleUser)
                        } label: {
                            EventRowView(event: event)
                        }
                    }
                }
                .listStyle(.inset)
                .toolbarTitleDisplayMode(.inlineLarge)
                .navigationTitle("Events")
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        NavigationLink {
                            FilterPageView()
                        } label: {
                            Image(systemName: "slider.horizontal.3")
                        }
                    }
                }
                .refreshable {
                    generateAndFetchEvents(groups: nil, categories: nil, futureDays: 30, dataModel: datamodel)
                }
            }
        }
    }
}

#Preview {
    MainPageView()
        .environmentObject(DataModel())
}
