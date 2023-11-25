//
//  singleComment.swift
//  New Bee
//
//  Created by Oli 奥利奥 on 10/29/23.
//

import SwiftUI

struct singleComment: View {
    @EnvironmentObject var datamodel: DataModel
    @Binding var replyTo: Comment?
    var comment: Comment
    let time = "2023-10-01 4:00PM"
    var userid: String

    var body: some View {
        HStack {
            singleImage(img: UIImage(named: "myPic.jpg")!, size: 50)
                .padding(.leading)
            VStack(alignment: .leading) {
                HStack {
                    Text(comment.userid).font(.system(size: 15)).fontWeight(.heavy)
                    Spacer()
                    Text(dateToString(time: comment.time)).font(.system(size: 12)).foregroundColor(Color.gray).padding(.trailing)
                }
                .foregroundColor(Color.black)
                Text(comment.content).font(.system(size: 15))
                
                HStack{
                    Spacer()
                    Button("Reply"){
                        replyTo = comment
                    }.padding(.leading, 3.0).font(.system(size: 12))
                    
                    if comment.userid == userid {
                        Button("delete", systemImage: "trash"){
                            datamodel.deleteComment(cmtid: comment.id)
                        }.font(.system(size: 10)).padding(.trailing).labelStyle(.iconOnly)
                }
                }
            }.padding(.leading, 1.0)
        }
    }
}

#Preview {
    singleComment(replyTo: .constant(nil), comment: sampleComment, userid: User.sampleUser.userid).environmentObject(DataModel())
}
