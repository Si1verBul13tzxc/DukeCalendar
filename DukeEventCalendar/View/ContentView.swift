//
//  ContentView.swift
//  DukeEventCalendar
//
//  Created by xz353 on 10/28/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        MainPageView()
    }
}

#Preview {
    ContentView()
        .environmentObject(DataModel())
}
