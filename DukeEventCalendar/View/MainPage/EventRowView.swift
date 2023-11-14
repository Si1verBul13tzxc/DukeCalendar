//
//  EventRowView.swift
//  DukeEventCalendar
//
//  Created by xz353 on 11/2/23.
//

import SwiftUI

struct EventRowView: View {
    let event: Event
    var body: some View {
        VStack(alignment: .leading) {
            eventImage
            Text(event.summary).fontWeight(.bold)
            Text(getFormattedDate(time: event.start_timestamp)).fontWeight(.semibold)
                .foregroundStyle(.gray)
            Text(event.sponsor).underline()
            HStack {
                Image(systemName: "mappin")
                Text(event.location.address)
                Spacer()
            }
        }

    }

    var eventImage: some View {
        AsyncImage(url: event.image) { image in
            image
                .resizable()
                .clipShape(
                    RoundedRectangle(
                        cornerSize: CGSize(
                            width: 10,
                            height: 10
                        )
                    )
                )
        } placeholder: {
            Image("event_default")
                .resizable()
                .clipShape(
                    RoundedRectangle(
                        cornerSize: CGSize(
                            width: 10,
                            height: 10
                        )
                    )
                )
        }
        .aspectRatio(2.5, contentMode: .fit)
        .shadow(radius: 15)
    }
}

#Preview {
    EventRowView(event: DataModel.sampleEvents![0])
}
