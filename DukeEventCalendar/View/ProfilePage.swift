//
//  ProfilePage.swift
//  DukeEventCalendar
//
//  Created by Oli 奥利奥 on 11/21/23.
//

import SwiftUI

struct ProfilePage: View {
    @EnvironmentObject var user: User

    var body: some View {
        NavigationView {
            VStack {
                singleImage(img: UIImage(systemName: "person.circle.fill")!, size: 200)
                    .padding(.bottom)
                Text(user.userid).font(.system(size: 30)).fontWeight(.heavy)
                    .padding(.horizontal, 20.0)

                Button("Log Out") {
                    user.userid = ""
                    user.isLoggedin = false
                }

            }
            .foregroundColor(.black)
        }
    }
}

#Preview {
    ProfilePage().environmentObject(User())
}
