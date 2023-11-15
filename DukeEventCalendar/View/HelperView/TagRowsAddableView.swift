//
//  TagRowsView.swift
//  DukeEventCalendar
//
//  Created by xz353 on 11/13/23.
//

import SwiftUI

struct TagRowsAddableView: View {
    @ObservedObject var tagRows: TagRows
    @ObservedObject var tagRowsSaved: TagRows
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 4) {
                ForEach(tagRows.rows, id: \.self) { row in
                    HStack(spacing: 6) {
                        ForEach(row) { tag in
                            Button {
                                withAnimation {
                                    tagRowsSaved.addTag(tag: tag)
                                }
                            } label: {
                                CategoryTag(category: tag.name)
                            }
                        }
                    }
                    .frame(height: 28)
                    .padding(.bottom, 10)
                }
            }
            .padding(.top)
        }
    }
}

#Preview {
    TagRowsAddableView(tagRows: TagRows.categoriesTagRows, tagRowsSaved: TagRows())
}
