//
//  FollowingGroups.swift
//  DukeEventCalendar
//
//  Created by Oli 奥利奥 on 11/8/23.
//

import SwiftUI

struct FollowingGroups: View {
    @EnvironmentObject var datamodel:DataModel
    @ObservedObject var user: User
    
    var body: some View {
        NavigationView{
            List{
                ForEach(user.getFollowings(), id: \.self){ group in
                    NavigationLink (group){
                        groupDetail(user: user, group: group)
                    }
                }
            }
            .navigationTitle("Following")
        }
    }
}

#Preview {
    FollowingGroups(user: sampleUser2).environmentObject(DataModel())
}
