//
//  EventCard.swift
//  DukeEventCalendar
//
//  Created by Oli 奥利奥 on 11/26/23.
//

import SwiftUI

struct EventCard: View {
    //    @Binding var event: Event?
    var event: Event
    var body: some View {
        //        if event != nil{
        ZStack {
            VStack {
                EventImage(imgURL: event.image)
                    .scaledToFit()
                    .transition(.opacity)
                    .scaledToFill()
                    .frame(width: 200, height: 200)
                    .clipped()
                Text(event.summary).font(.system(size: 25))
                    .fontWeight(.black)
                    .padding(.horizontal, 45.0)
                    .tint(.black)
            }
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color(CGColor(gray: 0.3, alpha: 0.2)))
        }
        .frame(width: 300, height: 380)
        //        }
    }
}

#Preview {
    EventCard(event: sampleEvents![6])
}
