//
//  FilterPageView.swift
//  DukeEventCalendar
//
//  Created by xz353 on 11/6/23.
//

import SwiftUI

struct FilterPageView: View {
    @EnvironmentObject var datamodel: DataModel
    @StateObject var categoryTagRows = TagRowsSearchable()
    @StateObject var groupTagRows = TagRowsSearchable()
    //@StateObject var savedTags = TagRows()
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    Text("Filter")
                        .font(.title)
                    Text("Show events within").fontWeight(.bold)

                    HStack {
                        Slider(value: $datamodel.futureDays, in: 1.0...30.0, step: 1.0)
                            .frame(width: 250)
                        Spacer()
                        Text("\(Int(datamodel.futureDays)) days").padding()
                    }
                    Divider()
                    Toggle(isOn: $datamodel.excludeOngoing) {
                        Text("Show events that haven't started")
                    }
                    .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                    .toggleStyle(iOSCheckboxToggleStyle())
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    Divider()
                    categoriesEdit
                    Divider()
                    groupEdit
                }
                .padding()
            }
        }
        .onAppear {
            do {
                let categories: [String] = try load("Categories.json")
                categoryTagRows.addTags(tagNames: categories)
                let groups: [String] = try load("Groups.json")
                groupTagRows.addTags(tagNames: groups)
            }
            catch {
                print(error.localizedDescription)
            }
        }
        .onDisappear {
            datamodel.updateEvents()
        }
    }

    var categoriesEdit: some View {
        Group {
            SearchBarView(
                searchFieldDefault: "Search Categories",
                searchText: $categoryTagRows.tagText
            )
            Text("Added Categories")
            TagRowsDeletableView(tagType: .Category, tagRows: datamodel.savedCateTags)
            Divider()
            Text("Category Suggestions:")
            if categoryTagRows.tagText == "" {
                TagRowsAddableView(
                    tagType: .Category,
                    tagRows: TagRows.suggestedCategoriesTagRows,
                    tagRowsSaved: datamodel.savedCateTags
                )
            }
            else {
                TagRowsAddableView(
                    tagType: .Category,
                    tagRows: categoryTagRows,
                    tagRowsSaved: datamodel.savedCateTags
                )
            }
        }
    }

    var groupEdit: some View {
        Group {
            SearchBarView(
                searchFieldDefault: "Search Groups",
                searchText: $groupTagRows.tagText
            )
            Text("Added Groups")
            TagRowsDeletableView(tagType: .Group, tagRows: datamodel.savedGroupTags)
            Divider()
            TagRowsAddableView(
                tagType: .Group,
                tagRows: groupTagRows,
                tagRowsSaved: datamodel.savedGroupTags
            )
        }
    }
}

#Preview {
    FilterPageView()
        .environmentObject(DataModel())
}
