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
    @State var input = ""
    var eventid: String
    var userid: String
    
    var body: some View {
        HStack{
                TextField("", text: $input, prompt: Text("Add a comment...")).disableAutocorrection(true).frame(height: 20.0)
                    .textFieldStyle(.roundedBorder).onSubmit {
                    }
                if input != "" {
                    Button(action: {
                        
                        datamodel.addComment(comment: Comment(eventid: eventid, userid: userid, content: input, time: .now))
                    }) {
                        Label("Post", systemImage: "paperplane")
                            .labelStyle(.titleOnly)
                    }
                }
        }
        .padding(.horizontal)
    }
}

#Preview {
    //@State var visible = true
    newComment(eventid: sample_event.id, userid: sampleUser.userid).environmentObject(DataModel())
}
