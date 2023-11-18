//
//  CategoryTags.swift
//  DukeEventCalendar
//
//  Created by Oli 奥利奥 on 11/15/23.
//not used

import SwiftUI

struct CategoryTags: View {
    var cats: [String]

    var body: some View {
        GeometryReader { geometry in
            self.generateContent(in: geometry)
        }
    }

    private func generateContent(in g: GeometryProxy) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero

        return ZStack(alignment: .topLeading) {
            ForEach(self.cats, id: \.self) { cat in
                CategoryTag(category: cat, fontSize: 12)
                    .padding([.horizontal, .vertical], 4)
                    .alignmentGuide(
                        .leading,
                        computeValue: { d in
                            if abs(width - d.width) > g.size.width {
                                width = 0
                                height -= d.height
                            }
                            let result = width
                            if cat == self.cats.last! {
                                width = 0  //last item
                            }
                            else {
                                width -= d.width
                            }
                            return result
                        }
                    )
                    .alignmentGuide(
                        .top,
                        computeValue: { d in
                            let result = height
                            if cat == self.cats.last! {
                                height = 0  // last item
                            }
                            return result
                        }
                    )
            }
        }
    }
}

#Preview {
    CategoryTags(cats: sample_event.categories!)
}
