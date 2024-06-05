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
        NavigationLink(destination: DetailedPosts(post: post, likeCount: likeCount, repostCount: repostCount, isLiked: isLiked, isReposted: isReposted)) {
            VStack {
                HStack(alignment: .top, spacing: 12) {
                    CircularProfilePictureView(profilePictureURL: user?.pfpUrl)
                        .frame(width: UIScreen.main.bounds.width * 0.12, height: UIScreen.main.bounds.width * 0.12)
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            if let user = user {
                                NavigationLink(destination: Profile(user: user)) {
                                    Text(user.username)
                                        .font(.footnote)
                                        .fontWeight(.semibold)
                                    Spacer()
                                }
                            } else {
                                Text("it no work")
                                    .font(.footnote)
                                    .fontWeight(.semibold)
                                Spacer()
                            }

                            Text(PostData.shared.relativeTimeString(from: post.postedAt))
                                .font(.caption)
                                .foregroundColor(Color("LTBL"))

                            Button {
                                deleteaction.toggle()
                            } label: {
                                Image(systemName: "ellipsis")
                                    .foregroundColor(Color("LTBL"))
                            }
                            
                            if deleteaction {
                                VStack(spacing: 8) {
                                    ForEach(PostData.UserPostEditOptions.allCases, id: \.self) { option in
                                        Button(action: {
                                            withAnimation {
                                                deleteaction.toggle()
                                            }
                                        }) {
                                            Text(option.rawValue)
                                                .foregroundColor(.white)
                                        }
                                    }
                                }
                                .padding()
                                .cornerRadius(8)
                            }
//                          .contextMenu {
//                              if post.postedBy == loggedInUserId {
//                              Button(action: {
//                                  // Handle edit action
//                              }) {
//                                  Label("Edit Post", systemImage: "pencil")
//                              }
//
//                              Button(action: {
//                                  // Handle delete action
//                              }) {
//                                  Label("Delete Post", systemImage: "trash")
//                              }
//
//                              Button(action: {
//                                  // Handle report action
//                              }) {
//                                  Label("Report Post", systemImage: "exclamationmark.triangle")
//                              }
//                          }
                }
                        Text(post.postText)
                            .font(.footnote)
                            .multilineTextAlignment(.leading)

                        if let mediaUrl = post.mediaUrl, let url = URL(string: mediaUrl) {
                            ExpandableImageView(imageUrl: url)
                        }

                        HStack(spacing: 16) {
                            Text("\(likeCount) likes • \(repostCount) reposts •  comments")
                                .font(.caption)
                                .foregroundColor(Color.gray)
                            Button {
                                isLiked.toggle() // Toggle the liked status
                                if isLiked {
                                    likeCount += 1
                                } else {
                                    likeCount -= 1
                                }
                                PostData.shared.likePost(postID: post.id!)
                            } label: {
                                Image(systemName: isLiked ? "heart.fill" : "heart")
                                    .foregroundColor(isLiked ? .red : Color("LTBL"))
                            }
                            NavigationLink(destination: DetailedPosts(post: post, likeCount: likeCount, repostCount: repostCount, isLiked: isLiked, isReposted: isReposted)) {
                                Button {
                                    // Handle button action here
                                } label: {
                                    Image(systemName: "bubble.right")
                                }}
                            Button {
                                isReposted.toggle()
                                PostData.shared.repostPost(postID: post.id!)
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
            .padding()
        }
    }
}

// Assuming DetailedPosts, CircularProfilePictureView, and UserData.fetchUser(by:) are defined elsewhere.
