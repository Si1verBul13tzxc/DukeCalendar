//
//  commentList.swift
//  New Bee
//
//  Created by Oli 奥利奥 on 10/29/23.
//

import SwiftUI

struct commentList: View {
    @EnvironmentObject var datamodel: DataModel
    var userid: String
    
    var eventid: String
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(datamodel.getComments(eventid: eventid).count) comments").font(.system(size: 15)).foregroundColor(Color.blue)
                .padding(.leading)

            ForEach(datamodel.getComments(eventid: eventid), id: \.self) { comment in
                singleComment(comment: comment, userid: userid)
                Divider().background(Color.gray)
            }

        }//.onAppear{ datamodel.addComment(comment: sampleComment) }

    }
}

#Preview {
    commentList(userid: sampleUser.userid, eventid: sample_event.id).environmentObject(DataModel())
}
