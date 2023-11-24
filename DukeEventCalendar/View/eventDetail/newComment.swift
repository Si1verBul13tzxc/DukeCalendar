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
    @Binding var isWindowVisible: Bool
    @Binding var isCommentPublished: Bool
    @State var input = ""
    var eventid: String
    var userid: String

    var body: some View {
        VStack {
            if replyTo != nil {
                HStack {

                    Text("Replying to \(replyTo!.userid)")
                        .foregroundStyle(Color(red: 0.4, green: 0.4, blue: 0.4))
                    Spacer()
                    Button("", systemImage: "xmark") {
                        replyTo = nil
                    }
                    .tint(.black)
                }
                .padding(.horizontal).padding(.vertical, 10.0)
                .background(Color(red: 0.9, green: 0.9, blue: 0.9))
            }
            HStack {
                TextField("", text: $input, prompt: Text("Add a comment..."))
                    .disableAutocorrection(true).frame(height: 20.0)
                    .textFieldStyle(.roundedBorder)  //.onSubmit {}
                    .onChange(of: replyTo) {
                        input = (replyTo != nil) ? "@\(replyTo!.userid) " : ""
                    }
                if input != "" {
                    Button(action: {
                        if datamodel.addComment(
                            comment: Comment(
                                eventid: eventid,
                                userid: userid,
                                content: input,
                                time: .now,
                                upperComment: replyTo?.upperComment ?? replyTo?.id
                            )
                        ) {
                            isCommentPublished = true
                            hideKeyboard()
                        }
                        else {
                            isCommentPublished = false
                        }
                        input = ""
                        replyTo = nil
                        isWindowVisible = true
                    }) {
                        Label("Post", systemImage: "paperplane")
                            .labelStyle(.titleOnly)
                    }
                }
            }
            .padding(.horizontal)
            .onAppear {
                input = (replyTo != nil) ? "@\(replyTo!.userid)" : ""
            }
        }
        .padding(.bottom, 20.0).padding(.top, 10)
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }
}

#Preview {
    //@State var visible = true
    newComment(
        replyTo: .constant(sampleComment),
        isWindowVisible: .constant(true),
        isCommentPublished: .constant(true),
        eventid: sample_event.id,
        userid: sampleUser.userid
    )
    .environmentObject(DataModel())
}
