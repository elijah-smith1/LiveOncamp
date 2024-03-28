//
//  FeedViewModel.swift
//  OnCampApp
//
//  Created by Elijah Smith on 11/7/23.
//

import Foundation

@MainActor
class feedViewModel: ObservableObject {
    @Published var Posts: [Post] = []
    
    
    
    
    

    func fetchFollowingPosts() async throws {
        do {

            let userIds = try await UserData.getFollowingDocumentIds()
           
            let postIds = try await PostData.fetchPostsForIds(for: userIds)
        
            self.Posts = try await PostData.fetchPostData(for: postIds)
            print ("DEBUG:: postIds ")
            print (postIds)
            print ("DEBUG:: userIds ")
            print (userIds)
            print("DEBOUG:: Posts")
            print (Posts)
            
        } catch {
            // Handle the error
            print("Error: \(error.localizedDescription)")
        }
    }
    
    func fetchFavoritePosts() async throws {
        do {

            let userIds = try await UserData.getFavoriteDocumentIds()
           
            let postIds = try await PostData.fetchPostsForIds(for: userIds)
            
            self.Posts = try await PostData.fetchPostData(for: postIds)
            print ("DEBUG:: postIds ")
            print (postIds)
            print ("DEBUG:: userIds ")
            print (userIds)
            print("DEBOUG:: Posts")
            print (Posts)
            
        } catch {
            // Handle the error
            print("Error: \(error.localizedDescription)")
        }
    }
    
    
    func fetchPublicPosts() async throws {
        do {
            // Call a method that gets public post IDs. Replace `fetchPublicPostsIDs` with your actual method name that returns [String]
            let postIDs = try await PostData.fetchPublicPosts()
            print(postIDs)
            
            print("Public Posts here")
            // Then fetch the full Post objects using those IDs
            self.Posts = try await PostData.fetchPostData(for: postIDs)
            
        } catch {
            // Handle errors
            // For example, show an error message to the user
            print("Error fetching public posts: \(error)")
        }
    }
}

