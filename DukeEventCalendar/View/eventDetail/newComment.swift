//
//  newComment.swift
//  New Bee
//
//  Created by Oli 奥利奥 on 10/29/23.
//

import SwiftUI

struct newComment: View {
    //@Binding var comment: String
    @State var input = ""
    @Binding var commentViewVisible: Bool
    
    var body: some View {
        HStack{
            Text("")
                TextField("", text: $input, prompt: Text("Required")).disableAutocorrection(true).frame(height: 20.0)
                    .textFieldStyle(.roundedBorder).onSubmit {
                        //comment = input
                        commentViewVisible = false
                    }
                if input != "" {
                    Button(action: {
                        //comment = input
                        commentViewVisible = false
                    }) {
                        Label("Post", systemImage: "paperplane")
                            .labelStyle(.titleOnly)
                    }
                }
        }
    }
}

#Preview {
    //@State var visible = true
    newComment(commentViewVisible: .constant(true))
}
