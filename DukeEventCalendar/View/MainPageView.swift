//
//  MainPageView.swift
//  DukeEventCalendar
//
//  Created by xz353 on 11/6/23.
//

import SwiftUI

struct MainPageView: View {
    var body: some View {
        NavigationStack {
            List {
                ForEach(DataModel.sampleEvents!, id: \.id) { event in
                    NavigationLink{
                        EventDetail(event: event)
                    }label: {
                        EventRowView(event: event)
                    }
                }
            }
            .listStyle(.inset)
            .navigationTitle(Text("Events"))
        }
    }
}

#Preview {
    MainPageView()
}
