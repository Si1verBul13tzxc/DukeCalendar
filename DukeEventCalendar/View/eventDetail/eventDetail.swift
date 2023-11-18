//
//  eventDetail.swift
//  New Bee
//
//  Created by Oli 奥利奥 on 10/29/23.
//

import EventKit
import EventKitUI
import SwiftUI

struct EventDetail: View {
    @EnvironmentObject var datamodel: DataModel
    @State private var saveToCalendar = false
    @State private var showCoSponsors = false
    @State private var showDesc = false

    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var event: Event
    @ObservedObject var user: User

    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ScrollView {
                    eventImage.scaledToFill().frame(height: 200).clipped()
                    VStack(alignment: .leading) {
                        Text(event.summary).font(.system(size: 25)).fontWeight(.heavy)  //summary
                        Text(event.status.rawValue).font(.system(size: 10)).foregroundColor(Color.gray)  //status
                        
                        HStack {
                            Text("By")  //sponsor?
                            NavigationLink(destination: groupDetail(user: user, group: event.sponsor)) {
                                Text(event.sponsor).multilineTextAlignment(.leading)
                                    .underline().scaledToFit()
                            }
                            
                            if event.co_sponsors != nil {
                                if showCoSponsors {
                                    Text(",")
                                }
                                else {
                                    Button("+ \(event.co_sponsors!.count)") {
                                        showCoSponsors.toggle()
                                    }
                                }
                            }
                        }
                        VStack(alignment: .leading) {
                            if showCoSponsors {
                                ForEach(event.co_sponsors!, id: \.self) { sponsor in
                                    HStack(alignment: .bottom) {
                                        NavigationLink(
                                            destination: groupDetail(user: user, group: sponsor)
                                        ) {
                                            Text("\(sponsor)").multilineTextAlignment(.leading)
                                                .underline()
                                        }
                                        if sponsor != event.co_sponsors!.last {
                                            Text(",")
                                        }
                                    }
                                }
                                HStack{
                                    Spacer()
                                    Button("Hide") {
                                        showCoSponsors.toggle()
                                    }
                                    .padding(.trailing, 20.0)
                                }
                            }
                        }.padding(.leading, 28.0)
                        
                        Text("")
                        
                        Text(
                            "\(dateToString(time:event.start_timestamp)) to \(dateToString(time:event.end_timestamp))"
                        )
                        HStack {
                            Image(systemName: "mappin")
                                .foregroundColor(.red)
                            Text(event.location.address)
                            
                            if let url = event.location.link {
                                Button(
                                    "",
                                    systemImage: "map",
                                    action: { UIApplication.shared.open(url) }
                                )
                            }
                        }
                        // 　link to map
                        if showDesc {
                            ZStack {
                                RoundedRectangle(cornerRadius: 5)
                                    .foregroundColor(Color(CGColor(gray: 0.3, alpha: 0.2)))
                                Text(event.description).font(.system(size: 13))
                            }
                            Button("Hide Description") { showDesc.toggle() }
                        }
                        else {
                            Button("Show Description") { showDesc.toggle() }
                        }
                    }
                    .padding(.horizontal)
                    
                    Divider()
                    if let cats = event.categories {
                        self.catTags(in: geometry, in: cats)
                    }
                    
                    Divider()
                    commentList(userid: user.userid, eventid: event.id)
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            saveToCalendar.toggle()
                        }
                        ) {
                            Label("Add to calendar", systemImage: "calendar.badge.plus")
                                .labelStyle(.iconOnly)
                        }
                        .sheet(
                            isPresented: $saveToCalendar,
                            content: {
                                EventEditViewController(dukeEvent: event)
                            }  //!!!
                        )
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            if user.isInterested(event: event) {
                                self.user.rmInterested(event: event)
                            }
                            else {
                                user.setAsInterested(event: event)
                            }
                        }
                        ) {
                            if user.isInterested(event: event) {
                                Label("Set as interested", systemImage: "star.fill")
                                    .labelStyle(.iconOnly)
                            }
                            else {
                                Label("Set as not interested", systemImage: "star")
                                    .labelStyle(.iconOnly)
                            }
                        }
                        .tint(user.isInterested(event: event) ? Color.yellow : Color.gray)
                    }
                    
                    ToolbarItem(placement: .topBarLeading) {
                        Button("back", systemImage: "chevron.backward") {
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    }
                    
                }}
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarHidden(true)

        newComment(eventid: event.id, userid: user.userid)
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
    
    
    
    private func catTags(in g: GeometryProxy, in cats: [String]) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero

        return ZStack(alignment: .topLeading) {
            ForEach(cats, id: \.self) { cat in
                CategoryTag(category: cat, fontSize: 12)
                    .padding([.horizontal, .vertical], 4)
                    .alignmentGuide(
                        .leading,
                        computeValue: { d in
                            if abs(width - d.width) > g.size.width {
                                width = 0
                                height -= d.height
                            }
                            let result = width
                            if cat == cats.last! {
                                width = 0  //last item
                            }
                            else {
                                width -= d.width
                            }
                            return result
                        }
                    )
                    .alignmentGuide(
                        .top,
                        computeValue: { d in
                            let result = height
                            if cat == cats.last! {
                                height = 0  // last item
                            }
                            return result
                        }
                    )
            }
        }
    }
}

#Preview {
    EventDetail(event: sample_event, user: sampleUser).environmentObject(DataModel())
}
