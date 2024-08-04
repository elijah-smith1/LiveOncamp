//
//  Home .swift
//  letsgetrich
//
//  Created by Michael Washington on 9/9/23.
//

import SwiftUI

struct Feed: View {
    @StateObject var viewModel = feedViewModel()
    @State private var selectedFeed = "School"
    let feedOptions = ["Following", "Favorites", "School"]

    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text("On")
                        .foregroundColor(Color("LTBL"))
                        .font(.title)
                        .italic()
                    
                    Text("Camp!")
                        .padding(.leading, -10)
                        .foregroundColor(.blue)
                        .font(.title)
                        .italic()
                    
                    Spacer()
                    
                    Menu(selectedFeed) {
                        ForEach(feedOptions, id: \.self) { option in
                            Button(action: {
                                selectedFeed = option
                                Task {
                                    switch selectedFeed {
                                    case "Following":
                                        try? await viewModel.fetchFollowingPosts()
                                    case "Favorites":
                                        try? await viewModel.fetchFavoritePosts()
                                    case "School":
                                        try? await viewModel.fetchMixedFeedItems()
                                    default:
                                        break
                                    }
                                }
                            }) {
                                Label(option, systemImage: "circle")
                            }
                        }
                    }
                }
                .padding()

                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(viewModel.mixedFeedItems) { item in
                            item.contentView
                            
                            Divider()
                        }
                    }
                }
            }
            .onAppear {
                Task {
                    await viewModel.fetchMixedFeedItems()
                }
            }
        }
        .navigationBarBackButtonHidden()
    }
}
