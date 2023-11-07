//
//  EventRowView.swift
//  DukeEventCalendar
//
//  Created by xz353 on 11/2/23.
//

import SwiftUI

struct EventRowView: View {
    let event: Event
    @State var showImage: Bool = false
    var body: some View {
        ScrollView(.horizontal) {
            VStack(alignment: .leading) {
                Text(event.summary).fontWeight(.bold)
                Text(getFormattedDate(time: event.start_timestamp)).fontWeight(.semibold)
                    .foregroundStyle(.gray)
                HStack {
                    Text("By")
                    Text(event.sponsor).offset(CGSize(width: -5, height: 0)).underline()
                }
                HStack {
                    Image(systemName: "mappin")
                    Text(event.location.address)
                    Spacer()
                }
                Button {
                    withAnimation {
                        showImage.toggle()
                    }
                } label: {
                    if !showImage {
                        Text("Show Image")
                            .foregroundStyle(Color(.blue))
                    }
                    else {
                        Text("Hide Image")
                            .foregroundStyle(Color(.blue))
                    }
                }
                if showImage {
                    eventImage.frame(width: UIScreen.main.bounds.width * 0.85)
                }
            }
            .padding()
        }
    }

    var eventImage: some View {
        AsyncImage(url: event.image) { image in
            image.resizable()
                .clipShape(
                    RoundedRectangle(
                        cornerSize: CGSize(
                            width: 10,
                            height: 10
                        )
                    )
                )
        } placeholder: {
            Text(event.image_alt_text ?? "Image Unavailable")
        }
        .scaledToFit()
        .transition(.opacity)
    }
}

#Preview {
    EventRowView(event: DataModel.sampleEvents![0])
}
