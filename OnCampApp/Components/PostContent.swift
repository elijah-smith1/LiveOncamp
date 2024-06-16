//
//  PostOptions.swift
//  OnCampApp
//
//  Created by Michael Washington on 6/5/24.
//

import SwiftUI

struct PostContent: View {
    var postText: String
    var mediaUrl: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(postText)
                .font(.footnote)
                .multilineTextAlignment(.leading)

            if let mediaUrl = mediaUrl, let url = URL(string: mediaUrl) {
                ExpandableImageView(imageUrl: url)
            }
        }
    }
}

//#Preview {
//    PostContent()
//}
