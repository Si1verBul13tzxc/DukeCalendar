//
//  ContentView.swift
//  DukeEventCalendar
//
//  Created by xz353 on 10/28/23.
//

import SwiftUI

struct ContentView: View {
    var loader1 = WebPageLoader()
    var loader2 = WebPageLoader()
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            
            Button("Load Options") {
                generateAndFetchEvents(groups: nil, categories: nil, futureDays: 1)
            }
             
        }
        .padding()
        .onAppear(){
            let urlString = "https://urlbuilder.calendar.duke.edu/"
            if let url = URL(string: urlString) {
                loader1.loadOptions(from: url, selectElementID: "categorieselect") { (options, error) in
                    if let options = options {
                        // Output to console
                        saveOptions(options: options, withFileName: "Categories.json")
                        //print(options.count)
                    } else if let error = error {
                        print("Error: \(error)")
                    }
                }
                loader2.loadOptions(from: url, selectElementID: "groupselect") { (options, error) in
                    if let options = options {
                        // Output to console
                        saveOptions(options: options, withFileName: "Groups.json")
                        //print(options.count)
                    } else if let error = error {
                        print("Error: \(error)")
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
