//
//  groupDetail.swift
//  DukeEventCalendar
//
//  Created by Oli 奥利奥 on 11/6/23.
//

import SwiftUI

struct groupDetail: View {
    @EnvironmentObject var datamodel: DataModel
    @ObservedObject var user: User
    var group: String

    var body: some View {
        //NavigationView {
        VStack {
            Text(group).font(.system(size: 20)).fontWeight(.heavy)
            ZStack {
                RoundedRectangle(cornerSize: CGSize(width: 20, height: 20))
                    .fill(user.isFollowing(groupName: group) ? Color.gray : Color.blue)
                    .frame(width: 70, height: 30)
                Button(user.isFollowing(groupName: group) ? "Following" : "Follow") {
                    if user.isFollowing(groupName: group) {
                        user.unfollow(groupName: group)
                    }
                    else {
                        user.follow(groupName: group)
                    }
                }
                .font(.system(size: 11)).fontWeight(.bold)
                .tint(user.isFollowing(groupName: group) ? Color.black : Color.white)
            }
            GroupEventList(group: group)
        }
        //}
        //.navigationBarTitle("Group Page", displayMode: .inline)

    }
}

#Preview {
    groupDetail(user: sampleUser, group: "Duke Chapel").environmentObject(DataModel())
}
