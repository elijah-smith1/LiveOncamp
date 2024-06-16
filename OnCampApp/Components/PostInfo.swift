//
//  PostInfo.swift
//  OnCampApp
//
//  Created by Michael Washington on 6/5/24.
//

import SwiftUI

struct PostInfo: View {
    var likeCount: Int
    var repostCount: Int
    var commentCount: Int

    var body: some View {
        Text("\(likeCount) likes • \(repostCount) reposts • \(commentCount) comments")
            .font(.caption)
            .foregroundColor(Color.gray)
    }
}

//#Preview {
//    PostInfo()
//}
