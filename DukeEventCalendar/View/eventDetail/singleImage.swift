//
//  singleImage.swift
//  New Bee
//
//  Created by Oli 奥利奥 on 10/29/23.
//

import SwiftUI

struct singleImage: View {
    var img: UIImage
    var size: Double
    var body: some View {
        Image(uiImage: img)
            .resizable()
            .frame(width: size, height: size)
            .clipShape(Circle())
            .overlay {
                Circle().stroke(.white, lineWidth: 4)
            }
        .shadow(radius: 7)
    }
}

#Preview {
    singleImage(img: UIImage(named: "myPic.jpg")!, size: 300)
}

