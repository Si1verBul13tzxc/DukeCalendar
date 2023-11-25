//
//  LogInPage.swift
//  DukeEventCalendar
//
//  Created by Oli 奥利奥 on 11/21/23.
//

import SwiftUI

struct LogInPage: View {
    @EnvironmentObject var datamodel: DataModel
    @EnvironmentObject var user: User
    @State var userName = ""
    @State var msg = "hi"

    var body: some View {
        ZStack {
            Image("background").resizable().aspectRatio(contentMode: .fill)

            VStack {
                TextField("", text: $userName, prompt: Text("Enter username"))
                    .disableAutocorrection(true).frame(width: 370, height: 20.0)
                    .textFieldStyle(.roundedBorder)
                    .padding(.all)
                ZStack {
                    RoundedRectangle(cornerRadius: 5)
                        .foregroundColor(.blue).frame(width: 80, height: 40)
                    Button("log in") {
                        loginOrSignUp()
                    }
                    .foregroundColor(.white).fontWeight(.heavy)
                }
                Text(msg)

            }
            .padding(.top, 50.0)
        }
    }

    private func loginOrSignUp() {
        if userName.count == 0 {
            msg = "Username cannot be empty"
            return
        }
        let dto = CreateUserDTO(name: userName)

        createUser(dto) { result, error in
            if result == true {
                DispatchQueue.main.async {
                    user.userid = userName
                    user.isLoggedin = true
                }
            }
            else if let error = error {
                DispatchQueue.main.async {
                    msg = error.localizedDescription
                }
            }
        }
    }
}

#Preview {
    LogInPage()
        .environmentObject(DataModel())
        .environmentObject(User())
}
