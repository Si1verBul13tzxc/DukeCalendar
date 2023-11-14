//
//  Tags.swift
//  DukeEventCalendar
//
//  Created by xz353 on 11/13/23.
//

import Foundation
import UIKit

//source: https://medium.com/geekculture/tags-view-in-swiftui-e47dc6ce52e8
struct Tag: Identifiable, Hashable {
    var id = UUID().uuidString
    var name: String
    var size: CGFloat = 0
}

class TagRows: ObservableObject {

    @Published var rows: [[Tag]] = []
    @Published var tags: [Tag] = []
    @Published var tagText = ""

    init() {
        buildTagRows()
    }

    func buildTagRows() {
        var rows: [[Tag]] = []
        var currentRow: [Tag] = []

        var totalWidth: CGFloat = 0

        let screenWidth = UIScreen.screenWidth - 10
        let tagSpaceing: CGFloat =
            14 /*Leading Padding*/ + 14 /*Trailing Padding*/ + 6
            + 6 /*Leading & Trailing 6, 6 Spacing*/

        if !tags.isEmpty {

            for index in 0..<tags.count {
                self.tags[index].size = tags[index].name.getSize()
            }

            tags.forEach { tag in

                totalWidth += (tag.size + tagSpaceing)

                if totalWidth > screenWidth {
                    totalWidth = (tag.size + tagSpaceing)
                    rows.append(currentRow)
                    currentRow.removeAll()
                    currentRow.append(tag)
                }
                else {
                    currentRow.append(tag)
                }
            }

            if !currentRow.isEmpty {
                rows.append(currentRow)
                currentRow.removeAll()
            }

            self.rows = rows
        }
        else {
            self.rows = []
        }
    }

    func addTags(tagNames: [String]) {
        for name in tagNames {
            tags.append(Tag(name: name))
        }
        buildTagRows()
    }

    // add and build rows on the fly
    func addTag() {
        tags.append(Tag(name: tagText))
        tagText = ""
        buildTagRows()
    }

    //remove and build rows on the fly
    func removeTag(by id: String) {
        tags = tags.filter { $0.id != id }
        buildTagRows()
    }
}
