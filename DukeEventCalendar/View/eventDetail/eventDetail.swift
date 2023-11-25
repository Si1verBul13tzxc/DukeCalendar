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
    @State var replyTo: Comment?
    @State var isWindowVisible = false
    @State var isCommentPublished = false

    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var event: Event
    @ObservedObject var user: User

    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ScrollView {
                    ZStack {
                        VStack {
                            EventImage(imgURL: event.image).scaledToFit()
                                .transition(.opacity).scaledToFill().frame(height: 200).clipped()
                            VStack(alignment: .leading) {
                                Text(event.summary).font(.system(size: 28)).fontWeight(.heavy)  //summary
                                Text(event.status.rawValue).font(.system(size: 12))
                                    .foregroundColor(Color.gray)  //status

                                SponsorInfo(
                                    user: user,
                                    sponsor: event.sponsor,
                                    co_sponsors: event.co_sponsors
                                )

                                Text("")

                                Time_Loc_Desc(event: event)
                            }
                            .padding(.horizontal)

                            Divider()
                            if let cats = event.categories {
                                self.catTags(in: geometry, in: cats)
                            }

                            Divider()
                            commentList(replyTo: $replyTo, userid: user.userid, eventid: event.id)
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
                                    }
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
                        }
                        if isWindowVisible {
                            FloatingWindow(
                                msg: isCommentPublished ? "Comment published" : "Comment failed"
                            )
                            .onAppear {
                                // Schedule the task to hide the window after 2 sec
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    withAnimation {
                                        isWindowVisible = false
                                    }
                                }
                            }
                        }

                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarHidden(true)
        //        .onTapGesture {
        //            hideKeyboard()
        //        }

        newComment(
            replyTo: $replyTo,
            isWindowVisible: $isWindowVisible,
            isCommentPublished: $isCommentPublished,
            eventid: event.id,
            userid: user.userid
        )
    }

    //https://github.com/qizhemotuosangeyan/blog/blob/master/SwiftUI%E8%87%AA%E5%8A%A8%E6%8D%A2%E8%A1%8CHStack.md
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
    EventDetail(event: sampleEvents![6], user: sampleUser).environmentObject(DataModel())
}
