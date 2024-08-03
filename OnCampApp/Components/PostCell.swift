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
    @State private var showOverlay = false

    var body: some View {
        ZStack {
            NavigationLink(destination: DetailedPosts(post: post, likeCount: likeCount, repostCount: repostCount, isLiked: isLiked, isReposted: isReposted)) {
                VStack {
                    HStack(alignment: .top, spacing: 12) {
                        CircularProfilePictureView(profilePictureURL: user?.pfpUrl)
                            .frame(width: UIScreen.main.bounds.width * 0.12, height: UIScreen.main.bounds.width * 0.12)
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Username(user: user)
                                PostDate(post: post)
                                Spacer()
                                Button(action: {
                                    showOverlay.toggle()
                                }) {
                                    Image(systemName: "ellipsis")
                                        .foregroundColor(Color("LTBL"))
                                }
                            }
                            PostContent(postText: post.postText, mediaUrl: post.mediaUrl)
                            PostInfo(likeCount: likeCount, repostCount: repostCount, commentCount: 0)
                            PostActions(isLiked: $isLiked, likeCount: $likeCount, isReposted: $isReposted, repostCount: $repostCount, postID: post.id!, post: post)
                        }
                    }
                    Divider()
                }
                .onAppear {
                    Task {
                        await initializeData()
                    }
                }
                .padding()
            }

            if showOverlay {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        withAnimation {
                            showOverlay.toggle()
                        }
                    }

                VStack {
                    Spacer()
                    VStack(spacing: 8) {
                        ForEach(PostData.UserPostEditOptions.allCases, id: \.self) { option in
                            Divider()
                            Button(action: {
                                withAnimation {
                                    deleteaction.toggle()
                                    showOverlay.toggle()
                                }
                            }) {
                                Text(option.rawValue)
                                    .foregroundColor(.red)
                            }
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
                    .shadow(radius: 5)
                    .padding()
                    .transition(.move(edge: .bottom))
                    .animation(.spring())
                }
            }
        }
    }
    
    private func initializeData() async {
        do {
            isLiked = try await viewModel.fetchLikeStatus(postId: post.id!, userId: loggedInUid!)
            isReposted = try await viewModel.fetchRepostStatus(postId: post.id!, userId: loggedInUid!)
            likeCount = try await viewModel.fetchLikes(postID: post.id!)
            repostCount = try await viewModel.fetchReposts(postID: post.id!)
            self.user = try await viewModel.fetchUser(for: post.postedBy)
        } catch {
            print("Failed to fetch data: \(error)")
        }
    }
}

struct Username: View {
    var user: User?
    
    var body: some View {
        if let user = user {
            Text(user.username)
                .foregroundColor(.primary)
        } else {
            Text("Unknown User")
                .font(.headline)
                .foregroundColor(.gray)
        }
    }
}
