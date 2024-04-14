//
//  Home .swift
//  letsgetrich
//
//  Created by Michael Washington on 9/9/23.
//

import SwiftUI


struct Feed: View {
    @StateObject var viewmodel = feedViewModel()
    @State var selectedFeed = "School"
    let feedOptions = ["Following", "Favorites", "School"]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                  
                    ForEach(viewmodel.Posts, id: \.id) { post in
                        PostCell(post: post)
                    }
                }
            }.onAppear {
                Task {
                    do {
                        
                        if viewmodel.Posts.isEmpty {
                            try await viewmodel.fetchPublicPosts()
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu(selectedFeed) {
                        ForEach(feedOptions, id: \.self) { option in
                            Button(action: {
                                selectedFeed = option
                                switch selectedFeed {
                                case "Following":
                                Task {
                                    do {
                                       try await viewmodel.fetchFollowingPosts()
                                        print ("Fetching following")
                                    } catch {
                      print("Error fetching following posts: \(error.localizedDescription)")
                                    }
                                }
                                case "Favorites":
                                    Task {
                                        do {
                                           try await viewmodel.fetchFavoritePosts()
                                            print("fetching favorites")
                                        } catch {
                          print("Error fetching following posts: \(error.localizedDescription)")
                                        }
                                    }
                                case "School":
                                    Task {
                                        do {
                                           try await viewmodel.fetchPublicPosts()
                                        } catch {
                          print("Error fetching following posts: \(error.localizedDescription)")
                                        }
                                    }
                                default:
                                    break
                                }
                            }) {
                                Label(option, systemImage: "circle")
                            }
                        }
                    }
                }
            }
        }
    }
}


//struct Feed__Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationStack{
//            Feed()
//         
//        }
//    }
//}
