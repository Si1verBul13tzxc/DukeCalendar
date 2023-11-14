//
//  FilterPageView.swift
//  DukeEventCalendar
//
//  Created by xz353 on 11/6/23.
//

import SwiftUI

struct FilterPageView: View {
    @EnvironmentObject var datamodel: DataModel
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("Sort and Filter")
                    .font(.title)
                Text("Show events within").fontWeight(.bold)

                HStack {
                    Slider(value: $datamodel.futureDays, in: 1.0...30.0, step: 1.0)
                        .frame(width: 250)
                    Spacer()
                    Text("\(Int(datamodel.futureDays)) days").padding()
                }
                Divider()
                Toggle(isOn: $datamodel.excludeOngoing) {
                    Text("Show events that haven't started")
                }
                .toggleStyle(iOSCheckboxToggleStyle())
                .fontWeight(.bold)
                .foregroundColor(.black)
            }
            .padding()
        }
    }
}

#Preview {
    FilterPageView()
        .environmentObject(DataModel())
}
