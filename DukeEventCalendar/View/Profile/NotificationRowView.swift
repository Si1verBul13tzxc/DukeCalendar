//
//  SwiftUIView.swift
//  DukeEventCalendar
//
//  Created by xz353 on 12/5/23.
//

import SwiftUI

struct NotificationRowView: View {
    let notification: LocalNotification

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .shadow(radius: 10)
                .foregroundStyle(Theme[notification.subtitle.count].mainColor.opacity(0.8))
            VStack(alignment:.leading){
                Text(notification.title)
                Text(notification.subtitle)
                Text(getFormattedDate(time:notification.datetime))
                    .foregroundStyle(.secondary)
            }
            .padding()
            .foregroundStyle(Color(Theme[notification.subtitle.count].accentColor))
        }
        .padding()
        .frame(height: 85)
        
    }
}

#Preview {
    NotificationRowView(
        notification: LocalNotification(
            id: "id",
            title: "ok",
            subtitle: "okoko will start in 30 min",
            datetime: Date.now
        )
    )
}
