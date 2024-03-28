//
//  PostCellViewModel.swift
//  OnCampApp
//
//  Created by Elijah and Mike on 2/6/24.
//

import Foundation
import Firebase
import FirebaseFirestore

class PostCellViewModel: ObservableObject {

    let db = Firestore.firestore()
 
    func fetchUser(for userId: String) async throws -> User {
        let userDocument = Userdb.document(userId)
        let documentSnapshot = try await userDocument.getDocument()

        let user: User
        do {
            user = try documentSnapshot.data(as: User.self)
        } catch {
            print("error fetching user: \(error)")
            throw error // Propagate the error upwards
        }
         
        return user
    }
    
    func fetchLikeStatus(postId: String, userId: String) async throws -> Bool {
       
        
        // Define the reference to the specific like document for the user and post
        let likeRef = Postdb.document(postId).collection("likes").document(userId)
        
        do {
            // Attempt to fetch the document
            let document = try await likeRef.getDocument()
            
            // Check if the document exists to determine if the user has liked the post
            if document.exists {
                return true
            } else {
                return false            }
        } catch {
            // Propagate any errors encountered during the fetch
            throw error
        }
    }   
    func fetchRepostStatus(postId: String, userId: String) async throws -> Bool {
        // follow the path of Posts/postId/reposts/userId
     
        let likeRef = Postdb.document(postId).collection("reposts").document(userId)
        
        do { let document = try await likeRef.getDocument()
            
            // Check if the document exists to determine if the user has liked the post
            if document.exists {
                return true
            } else {
                return false            }
        } catch {
            // Propagate any errors encountered during the fetch
            throw error
        }
    }
    func fetchLikes(postID: String) async throws -> Int {
        let query = Postdb.document(postID).collection("likes")
        let countQuery = query
        do {
            let snapshot = try await countQuery.getDocuments()
            let count = snapshot.documents.count
            print(count)
            return count
        } catch {
            throw error
        }
    }

    func fetchreposts(postID: String)async throws -> Int {
        let query = Postdb.document(postID).collection("reposts")
        let countQuery = query
        do {
            let snapshot = try await countQuery.getDocuments()
            let count = snapshot.documents.count
            print(count)
            return count
        } catch {
            throw error
        }
    }
}
