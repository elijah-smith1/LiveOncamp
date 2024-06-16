//
//  PostDate.swift
//  OnCampApp
//
//  Created by Michael Washington on 6/5/24.
//

import SwiftUI

struct PostDate: View {
    @ObservedObject var postData = PostData()
    var post: Post

    var body: some View {
        Text(PostData.shared.relativeTimeString(from: post.postedAt))
            .font(.caption)
            .foregroundColor(Color("LTBL"))
    }
}

//#Preview {
//    PostDate()
//}
