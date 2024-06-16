//
//  PostActions.swift
//  OnCampApp
//
//  Created by Michael Washington on 6/5/24.
//

import SwiftUI

struct PostActions: View {
    @Binding var isLiked: Bool
    @Binding var likeCount: Int
    @Binding var isReposted: Bool
    @Binding var repostCount: Int
    var postID: String
    var post: Post


    var body: some View {
        HStack(spacing: 16) {
            Button {
                isLiked.toggle() // Toggle the liked status
                if isLiked {
                    likeCount += 1
                } else {
                    likeCount -= 1
                }
                PostData.shared.likePost(postID: postID)
            } label: {
                Image(systemName: isLiked ? "heart.fill" : "heart")
                    .foregroundColor(isLiked ? .red : Color("LTBL"))
            }

            NavigationLink(destination: DetailedPosts(post: post, likeCount: likeCount, repostCount: repostCount, isLiked: isLiked, isReposted: isReposted)) {
                Button {
                    // Handle button action here
                } label: {
                    Image(systemName: "bubble.right")
                }
            }

            Button {
                isReposted.toggle()
                PostData.shared.repostPost(postID: postID)
                if isReposted {
                    repostCount += 1
                } else {
                    repostCount -= 1
                }
            } label: {
                Image(systemName: isReposted ? "arrow.rectanglepath" : "arrow.rectanglepath")
                    .foregroundColor(isReposted ? .green :  Color("LTBL"))
            }

            Button {
                //MARK: DM CAPABILITIES
                // Handle button action here
            } label: {
                Image(systemName: "paperplane")
            }
        }
        .foregroundColor(Color("LTBL"))
        .padding(.vertical, 8)
    }
}

//#Preview {
//    PostActions()
//}
