import SwiftUI

/*
 class ProfileViewModel: ObservableObject {
     @Published var posts: [Post] = []
     @Published var isLoading = false
     var userId: String
     
     init(userId: String) {
         self.userId = userId
         fetchData()
     }
     
     func fetchData() {
         isLoading = true
         // Simulate data fetching
         DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
             // Update your posts, reposts, or likes based on the selected filter
             self.posts = [/* fetched posts */]
             self.isLoading = false
         }
     }
 }

 struct Profile: View {
     @EnvironmentObject var userData: UserData
     @State private var selectedFilter: ProfileTabFilter = .posts {
         didSet {
             viewModel.fetchData()
         }
     }
     @Namespace var animation
     @StateObject var viewModel: ProfileViewModel
     private let user: User
     
     init(user: User) {
         self.user = user
         _viewModel = StateObject(wrappedValue: ProfileViewModel(userId: user.id ?? ""))
     }
     
     var body: some View {
         NavigationStack {
             ScrollView(showsIndicators: false) {
                 VStack(spacing: 20) {
                     // Your existing UI components
                     if viewModel.isLoading {
                         ProgressView()
                     } else {
                         // Content based on selected filter
                         switch selectedFilter {
                         case .posts:
                             UserPostsView(posts: viewModel.posts)
                         case .reposts:
                             UserRepostsView(reposts: viewModel.posts) // Adjust according to your data structure
                         case .likes:
                             UserLikesView(likes: viewModel.posts) // Adjust according to your data structure
                         }
                     }
                 }
             }
         }
     }
 }
 */

struct Profile: View {
    @EnvironmentObject var userData: UserData
    @State private var selectedFilter: ProfileTabFilter = .posts
    @Namespace var animation
    @StateObject var viewModel: ProfileViewModel
    private let user: User
    
    init(user: User) {
           self.user = user
           _viewModel = StateObject(wrappedValue: ProfileViewModel(userId: user.id ?? ""))
       }
    
    private var filterBarWidth: CGFloat {
        let count = CGFloat(ProfileTabFilter.allCases.count)
        return UIScreen.main.bounds.width / count
    }
    
    var body: some View {
        NavigationStack{
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    Spacer()
                    ProfileHeaderCell(user: user)
                    Divider()
                    // Filter Bar
                    HStack {
                        ForEach(ProfileTabFilter.allCases, id: \.self) { filter in
                            FilterBarButton(filter: filter, selectedFilter: $selectedFilter, animation: animation, filterBarWidth: filterBarWidth)
                        }
                    }
                    
                    // Content based on selected filter
                    switch selectedFilter {
                    case .posts:
                        UserPostsView(viewModel: viewModel) // Replace with actual view
                    case .reposts:
                         UserRepostsView(viewModel: viewModel) // Replace with actual view
                    case .likes:
                        UserLikesView(viewModel: viewModel) // Replace with actual view
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

struct FilterBarButton: View {
    let filter: ProfileTabFilter
    @Binding var selectedFilter: ProfileTabFilter
    var animation: Namespace.ID
    var filterBarWidth: CGFloat
    
    var body: some View {
        VStack {
            Text(filter.title)
                .font(.subheadline)
                .fontWeight(selectedFilter == filter ? .semibold : .regular)
            
            if selectedFilter == filter {
                Rectangle()
                    .foregroundColor(Color("LTBL"))
                    .frame(width: filterBarWidth, height: 1)
                    .matchedGeometryEffect(id: "filterIndicator", in: animation)
            } else {
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: filterBarWidth, height: 1)
            }
        }
        .onTapGesture {
            withAnimation(.spring()) {
                selectedFilter = filter
            }
        }
    }
}

// Replace these with your actual views for posts, reposts, and likes




//struct Profile_Previews: PreviewProvider {
//    static var previews: some View {
//        Profile(user: sampleUser).environmentObject(UserData())
//    }
//}
