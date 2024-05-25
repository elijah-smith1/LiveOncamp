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
                HStack{
                    Text("On")
                        .foregroundColor(Color("LTBL")) // Custom color, ensure this exists in your assets
                        .font(.title)
                    
                    Text("Camp")
                        .padding(.leading, -10)
                        .foregroundColor(.blue) // Blue color for "Hub"
                        .font(.title)
                    Spacer()
                    Menu(selectedFeed) {
                        ForEach(feedOptions, id: \.self) { option in
                            Button(action: {
                                selectedFeed = option
                                switch selectedFeed {
                                case "Following":
//                                    Task {
//                                        do {
//                                            try await viewmodel.fetchFollowingPosts()
                                            print ("Fetching following")
//                                        } catch {
//                                            print("Error fetching following posts: \(error.localizedDescription)")
//                                        }
//                                    }
                                    
                                case "Favorites":
//                                    Task {
//                                        do {
//                                            try await viewmodel.fetchFavoritePosts()
                                            print("fetching favorites")
//                                        } catch {
//                                            print("Error fetching following posts: \(error.localizedDescription)")
//                                        }
//                                    }
                                    
                                case "School":
//                                    Task {
//                                        do {
//                                            try await viewmodel.fetchPublicPosts()
//                                        } catch {
                                            print("fetching posts")
//                                        }
//                                    }
                                default:
                                    break
                                }
                            }) {
                                Label(option, systemImage: "circle")
                            }
                        }
                    }
                }
                .padding()
                ScrollView {
                    VStack(spacing: 0) {
                        if selectedFeed == "Following" {
                            FollowingFeed()
                        } else if selectedFeed == "Favorites" {
                            FavoritesFeed()
                        } else if selectedFeed == "School" {
                            SchoolFeed()
                        }
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
