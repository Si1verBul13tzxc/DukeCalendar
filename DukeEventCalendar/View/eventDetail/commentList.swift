//
//  commentList.swift
//  New Bee
//
//  Created by Oli 奥利奥 on 10/29/23.
//

import SwiftUI

struct commentList: View {
    var cmtNum = 10
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(cmtNum) comments").font(.system(size: 15)).foregroundColor(Color.blue).padding(.leading)
            ForEach(1...10, id: \.self) { _ in
                singleComment()
                Divider().background(Color.gray)
            }

        }

    }
}

#Preview {
    commentList()
}
