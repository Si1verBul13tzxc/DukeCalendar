//
//  newComment.swift
//  New Bee
//
//  Created by Oli 奥利奥 on 10/29/23.
//

import SwiftUI

struct newComment: View {
    //@Binding var comment: String
    @EnvironmentObject var datamodel: DataModel
    @Binding var replyTo: Comment?
    @State var input = ""
    var eventid: String
    var userid: String
    
    var body: some View {
        VStack{
            HStack{
                TextField("",  text: $input, prompt: Text("Add a comment...")).disableAutocorrection(true).frame(height: 20.0)
                        .textFieldStyle(.roundedBorder)//.onSubmit {}
                        .onChange(of: replyTo) { 
                            input = (replyTo != nil) ? "@\(replyTo!.userid) " : ""
                        }
                    if input != "" {
                        Button(action: {
                            datamodel.addComment(comment: Comment(eventid: eventid, userid: userid, content: input, time: .now, upperComment: replyTo?.upperComment ?? replyTo?.id ))
                            input = ""
                            replyTo = nil
                        }) {
                            Label("Post", systemImage: "paperplane")
                                .labelStyle(.titleOnly)
                        }
                    }
            }
            .padding(.horizontal).onAppear() {
                input = (replyTo != nil) ? "@\(replyTo!.userid)" : ""
            }
        }
        .padding(.bottom, 20.0).padding(.top, 10)
    }
}

#Preview {
    //@State var visible = true
    newComment(replyTo: .constant(sampleComment), eventid: sample_event.id, userid: sampleUser.userid).environmentObject(DataModel())
}
