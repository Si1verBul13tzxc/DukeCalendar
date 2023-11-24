//
//  commentList.swift
//  New Bee
//
//  Created by Oli 奥利奥 on 10/29/23.
//

import SwiftUI

struct commentList: View {
    @EnvironmentObject var datamodel: DataModel
    @Binding var replyTo: Comment?
    var userid: String

    var eventid: String
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(datamodel.getComments(eventid: eventid).count) comments")
                .font(.system(size: 15)).foregroundColor(Color.blue)
                .padding(.leading)

            ForEach(datamodel.getMainComments(), id: \.self) { comment in
                singleComment(replyTo: $replyTo, comment: comment, userid: userid)
                ForEach(datamodel.getSubComments(cmtid: comment.id), id: \.self) { subComment in
                    singleComment(replyTo: $replyTo, comment: subComment, userid: userid)
                        .padding(.leading, 30.0)
                }
                Divider().background(Color.gray)
            }

        }  //.onAppear{ datamodel.addComment(comment: sampleComment) }
    }
}

#Preview {
    commentList(replyTo: .constant(nil), userid: sampleUser.userid, eventid: sample_event.id)
        .environmentObject(DataModel())
}
