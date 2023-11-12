//
//  singleComment.swift
//  New Bee
//
//  Created by Oli 奥利奥 on 10/29/23.
//

import SwiftUI

struct singleComment: View {
    let comment_id = 1
    let user_id = 1
    let event_id = 1
    let content = "This is my comment"
    let time = "2023-10-01 4:00PM"
    //find user info by user_id

    var body: some View {
        HStack {
            singleImage(img: UIImage(named: "myPic.jpg")!, size: 70)
                .padding(.leading)
            VStack(alignment: .leading) {
                HStack {
                    Text("Aoli Zhou").font(.system(size: 15)).fontWeight(.heavy)
                    Spacer()
                    Text(time).font(.system(size: 10)).foregroundColor(Color.gray).padding(.trailing)
                }
                .foregroundColor(Color.black)
                    Text(content).font(.system(size: 15))
            }
        }
    }
}

#Preview {
    singleComment()
}
