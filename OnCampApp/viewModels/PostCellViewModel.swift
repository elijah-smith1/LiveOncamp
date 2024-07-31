import Foundation
import Firebase
import FirebaseFirestore

class PostCellViewModel: ObservableObject {
    private let db = Firestore.firestore()

    func fetchUser(for userId: String) async throws -> User {
        let userDocument = Userdb.document(userId)
        let documentSnapshot = try await userDocument.getDocument()
        let user: User
        do {
            user = try documentSnapshot.data(as: User.self)
        } catch {
            print("Error fetching user: \(error)")
            throw error // Propagate the error upwards
        }
        return user
    }
    
    func fetchLikeStatus(postId: String, userId: String) async throws -> Bool {
        let likeRef = Postdb.document(postId).collection("likes").document(userId)
        do {
            let document = try await likeRef.getDocument()
            return document.exists
        } catch {
            throw error
        }
    }
    
    func fetchRepostStatus(postId: String, userId: String) async throws -> Bool {
        let repostRef = Postdb.document(postId).collection("reposts").document(userId)
        do {
            let document = try await repostRef.getDocument()
            return document.exists
        } catch {
            throw error
        }
    }
    
    func fetchLikes(postID: String) async throws -> Int {
        let query = Postdb.document(postID).collection("likes")
        do {
            let snapshot = try await query.getDocuments()
            return snapshot.documents.count
        } catch {
            throw error
        }
    }

    func fetchReposts(postID: String) async throws -> Int {
        let query = Postdb.document(postID).collection("reposts")
        do {
            let snapshot = try await query.getDocuments()
            return snapshot.documents.count
        } catch {
            throw error
        }
    }
}
