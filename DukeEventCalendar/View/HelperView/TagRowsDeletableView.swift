//
//  TagRowsDeletableView.swift
//  DukeEventCalendar
//
//  Created by xz353 on 11/14/23.
//

import SwiftUI

struct TagRowsDeletableView: View {
    @ObservedObject var tagRows: TagRows
    @State private var shake: Bool = false
    @State private var isDeleting: Bool = false
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 4) {
                ForEach(tagRows.rows, id: \.self) { row in
                    HStack(spacing: 6) {
                        ForEach(row) { tag in
                            if !isDeleting {
                                CategoryTag(category: tag.name, fontSize: 16)
                            }
                            else {
                                Button {
                                    withAnimation {
                                        tagRows.removeTag(by: tag.id)
                                    }
                                } label: {
                                    CategoryTagDeletable(category: tag.name)
                                }
                            }
                        }
                    }
                    .frame(height: 28)
                    .padding(.bottom, 10)
                }
            }
            .padding(.top)
            .padding(.trailing)
            .onLongPressGesture {
                shake = true
            }
            .shake($shake) {
                isDeleting.toggle()
            }
        }
    }
}

#Preview {

    TagRowsDeletableView(tagRows: TagRows.categoriesTagRows)
}
