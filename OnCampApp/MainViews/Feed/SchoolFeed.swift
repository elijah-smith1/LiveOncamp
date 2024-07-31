import SwiftUI

struct SchoolFeed: View {
    @StateObject private var viewModel: feedViewModel

    init() {
        let viewModel = feedViewModel()
        self._viewModel = StateObject(wrappedValue: viewModel)
        
        // Fetch the posts synchronously in the init method
        Task {
           try await viewModel.fetchPublicPosts()
        }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                ForEach(viewModel.Posts, id: \.id) { post in
                    PostCell(post: post)
                }
            }
        }
    }
}

#Preview {
    SchoolFeed()
}
