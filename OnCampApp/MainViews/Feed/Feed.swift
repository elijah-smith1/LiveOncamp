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
    
    @State private var titleOffset: CGFloat = -300 // Start title offscreen
    @State private var titleScale: CGFloat = 0.5 // Start small for bounce-in effect

    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text("On")
                        .foregroundColor(Color("LTBL"))
                        .font(.title)
                        .italic()
                        .offset(x: titleOffset)
                        .scaleEffect(titleScale)
                        .animation(.interpolatingSpring(stiffness: 50, damping: 5).delay(0.1), value: titleOffset)
                    
                    Text("Camp!")
                        .padding(.leading, -10)
                        .foregroundColor(.blue)
                        .font(.title)
                        .italic()
                        .offset(x: titleOffset)
                        .scaleEffect(titleScale)
                        .animation(.interpolatingSpring(stiffness: 50, damping: 5).delay(0.1), value: titleOffset)
                    
                    Spacer()
                    
                    Menu(selectedFeed) {
                        ForEach(feedOptions, id: \.self) { option in
                            Button(action: {
                                selectedFeed = option
                                switch selectedFeed {
                                case "Following":
                                    // Your fetch following posts logic here
                                    print("Fetching following")
                                case "Favorites":
                                    // Your fetch favorite posts logic here
                                    print("Fetching favorites")
                                case "School":
                                    // Your fetch public posts logic here
                                    print("Fetching school posts")
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
            }
            .onAppear {
                titleOffset = 0 // Animate title to original position
                titleScale = 1.0 // Animate title to full size
                Task {
                    do {
                        if viewmodel.Posts.isEmpty {
                            try await viewmodel.fetchPublicPosts()
                        }
                    } catch {
                        print("Error fetching posts: \(error.localizedDescription)")
                    }
                }
            }
        }
        .navigationBarBackButtonHidden()
    }
}


