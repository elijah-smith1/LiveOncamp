//
//  FeedViewModel.swift
//  OnCampApp
//
//  Created by Elijah Smith on 11/7/23.
//

import Foundation
// populate some reposts into the feed as well
@MainActor
class feedViewModel: ObservableObject {
    @Published var Posts: [Post] = []
    
    func fetchFollowingPosts() async throws {
        do {

            let userIds = try await UserData.getFollowingDocumentIds()
           
            self.Posts = try await PostData.fetchPostsForIds(for: userIds)
        
//             try await PostData.fetchPostData(for: postIds)
        } catch {
            // Handle the error
            print("Error: \(error.localizedDescription)")
        }
    }
    
    func fetchFavoritePosts() async throws {
        do {
            let userIds = try await UserData.getFavoriteDocumentIds()
            self.Posts = try await PostData.fetchPostsForIds(for: userIds)
            
        } catch {
            // Handle the error
            print("Error: \(error.localizedDescription)")
        }
    }
    
    func fetchPublicPosts() async throws {
        do {
            // Call a method that gets public post IDs. Replace `fetchPublicPostsIDs` with your actual method name that returns [String]
            self.Posts = try await PostData.fetchPublicPosts()

        } catch {
            // Handle errors
            // For example, show an error message to the user
            print("Error fetching public posts: \(error)")
        }
    }
}

