import SwiftUI
import Firebase
import FirebaseFirestore
import Kingfisher

struct PostCell: View {
    @ObservedObject var postData = PostData()
    
    @State private var isLiked: Bool = false
    @State private var isReposted: Bool = false
    @State private var user: User?
    
    @State var likeCount: Int = 0
    @State var repostCount: Int = 0
    @State var deleteaction: Bool = false
    
    var post: Post
    @State private var selectedOption: PostData.UserPostEditOptions = .deletePost
    @StateObject var viewModel = PostCellViewModel()

    var body: some View {
        VStack {
            NavigationLink(destination: DetailedPosts(post: post, likeCount: likeCount, repostCount: repostCount, isLiked: isLiked, isReposted: isReposted)) {
                VStack {
                    HStack(alignment: .top, spacing: 12) {
                        CircularProfilePictureView(profilePictureURL: user?.pfpUrl)
                            .frame(width: UIScreen.main.bounds.width * 0.12, height: UIScreen.main.bounds.width * 0.12)
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Username(user: user)
                                PostDate(post: post)
                                Spacer() // Ensure ellipsis button is aligned to the right
                                PostOptionsButton(deleteaction: $deleteaction)
                            }
                            PostContent(postText: post.postText, mediaUrl: post.mediaUrl)
                            PostInfo(likeCount: likeCount, repostCount: repostCount, commentCount: post.commentCount ?? 0)
                            PostActions(isLiked: $isLiked, likeCount: $likeCount, isReposted: $isReposted, repostCount: $repostCount, postID: post.id!, post: post)
                        }
                    }
                }
                .padding()
            }
            Divider()
        }
        .onAppear {
            Task {
                do {
                    isLiked = try await viewModel.fetchLikeStatus(postId: post.id!, userId: loggedInUid!)
                    isReposted = try await viewModel.fetchRepostStatus(postId: post.id!, userId: loggedInUid!)
                    likeCount = try await viewModel.fetchLikes(postID: post.id!)
                    repostCount = try await viewModel.fetchreposts(postID: post.id!)
                    self.user = try await viewModel.fetchUser(for: post.postedBy)
                } catch {
                    print("Failed to fetch user: \(error)")
                }
            }
        }
    }
}

