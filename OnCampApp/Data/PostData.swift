//
//  PostData.swift
//  OnCampApp
//
//  Created by Michael Washington on 10/13/23.
//
import Observation
import Foundation
import Firebase
import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift
/* remove Favorite*/

@MainActor
 class PostData: ObservableObject {
    var isLiked: Bool = false
    static let shared = PostData()
    var posts: [Post] = []  // This will hold your posts and notify observers of any changes

    enum PostOption: String, CaseIterable, Identifiable {
        case publicPost = "Public"
        case followersPost = "Followers"
        case favoritesPost = "Favorites"
        var id: String { self.rawValue }
    }
    
    static func fetchPublicPosts() async throws -> [Post] {
        var posts = [Post]()
        let snapshot = try await Postdb
            .whereField("security", isEqualTo: PostOption.publicPost.rawValue)
            .order(by: "postedAt", descending: true)
            .limit(to: 25)
            .getDocuments()
        for document in snapshot.documents {
            var post = try document.data(as: Post.self)
            post.id = document.documentID
             posts.append(post)
        }
        print(posts)
        return posts
    }
    
    static func fetchPostsForIds(for userIds: [String]) async throws -> [Post] {
        let collectionReference = Firestore.firestore().collection("Posts")
        var allPosts: [Post] = []
        do {
            for userId in userIds {
                // executing the search on the data base and limiting the result to 25
                // need to add in some way to determine which ones to fetch after this 25. will start to track which post is actually viewed. but in a batch write at some point during session so im not writing everytime some one scrolls. or maybe as they are fetched
                let snapshot = try await collectionReference.whereField("postedBy", isEqualTo: userId).limit(to: 25).getDocuments()
                // takes the documents from the query result and ads them to the posts array by making a map of them
                for document in snapshot.documents {
                    var post = try document.data(as: Post.self)
                    post.id = document.documentID
                     allPosts.append(post)
                }
            }
            return allPosts
        } catch {
            // ig add some reporting at some point but fuck it
            throw error
        }
    }
    

    

    static func fetchPostsByUser(userId: String) async throws -> [Post] {
        var posts = [Post]()
        let snapshot = try await Postdb.whereField("postedBy", isEqualTo: userId).getDocuments()
        for document in snapshot.documents {
            var post = try document.data(as: Post.self)
            post.id = document.documentID
             posts.append(post)
        }
        print(posts)
        return posts
    }
    
    static func fetchRepostsforUID(Uid: String) async throws -> [Post] {
        var postIds = [String]()

        // Ensure that 'Userdb' is a reference to the Firestore collection containing user documents
        // For example, if your users collection is named "users", it should be initialized as follows:
        // let Userdb = Firestore.firestore().collection("users")
        let snapshot = try await Userdb.document(Uid).collection("reposts").getDocuments()
        for document in snapshot.documents {
            postIds.append(document.documentID)
        }
       let posts = try await self.fetchPostData(for: postIds)
        return posts
    }
     
    static func fetchLikesforUID(Uid: String) async throws -> [Post] {
        var postIds = [String]()
        // Ensure that 'Userdb' is a reference to the Firestore collection containing user documents
        // For example, if your users collection is named "users", it should be initialized as follows:
        // let Userdb = Firestore.firestore().collection("users")
        let snapshot = try await Userdb.document(Uid).collection("likes").getDocuments()
        for document in snapshot.documents {
            postIds.append(document.documentID)
        }
        let posts = try await self.fetchPostData(for: postIds)
         return posts
        
    }
     
    static func fetchPostData(for postIds: [String]) async throws -> [Post] {
        var posts: [Post] = []
        for postId in postIds {
            let documentSnapshot = try await Postdb.document(postId).getDocument()
            
            guard let data = documentSnapshot.data(), documentSnapshot.exists else {
                throw NSError(domain: "PostError", code: 404, userInfo: [NSLocalizedDescriptionKey: "Post not found"])
            }
            // Fetch the mediaUrl
            let mediaUrl = data["mediaUrl"] as? String
            let pfpUrl = data["pfpUrl"] as? String
            if let postText = data["content"] as? String,
               let postedBy = data["postedBy"] as? String,
               let timestamp = data["postedAt"] as? Timestamp,
               let likeCount = data["likeCount"] as? Int,
               let repostCount = data["repostCount"] as? Int,
               let commentCount = data["commentCount"] as? Int,
               let username = data["username"] as? String {
                let postedAt = Timestamp(date: timestamp.dateValue())
                let post = Post(
                    id: documentSnapshot.documentID,
                    postText: postText,
                    postedBy: postedBy,
                    postedAt: postedAt,
                    likeCount: likeCount,
                    repostCount: repostCount,
                    commentCount: commentCount,
                    username: username,
                    mediaUrl: mediaUrl, // Add the media URL to the Post object
                    pfpUrl: pfpUrl
                )
            
                posts.append(post)
                print("this function was ran here are the posts :::: \(posts)")
            } else {
                print("Document \(postId) is missing required data")
            }
        }

        return posts
    }
   
    
   


    func likePost(postID: String ) {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("User not logged in")
            return
        }

        let db = Firestore.firestore()
        let postRef = db.collection("Posts").document(postID)
        let userRef = db.collection("Users").document(userID)

        // Check if the post is already liked by the user
        postRef.collection("likes").document(userID).getDocument { (document, error) in
            if let error = error {
                print("Error checking like status: \(error.localizedDescription)")
                return
            }

            if let document = document, document.exists {
                // Post is already liked by the user, so unlike it
                postRef.collection("likes").document(userID).delete() { error in
                    if let error = error {
                        print("Error unliking post: \(error.localizedDescription)")
                    } else {
                        userRef.collection("likes").document(postID).delete() { error in
                            if let error = error {
                                print("Error removing liked post from user's collection: \(error.localizedDescription)")
                            } else {
                                print("Post unliked successfully!")
                            }
                        }
                    }
                }
            } else {

                postRef.collection("likes").document(userID).setData([:]) { error in
                    if let error = error {
                        print("Error liking post: \(error.localizedDescription)")
                    } else {
                        userRef.collection("likes").document(postID).setData([:]) { error in
                            if let error = error {
                                print("Error adding liked post to user's collection: \(error.localizedDescription)")
                            } else {
                                print("Post liked successfully!")
                            }
                        }
                    }
                }
            }
        }
    }
    func unLikePost(postID: String){
        guard let userID = Auth.auth().currentUser?.uid else {
            print("User not logged in")
            return
        }

        let db = Firestore.firestore()
        let postRef = db.collection("Posts").document(postID)
        let userRef = db.collection("Users").document(userID)

        // Check if the post is already liked by the user
        postRef.collection("likes").document(userID).getDocument { (document, error) in
            if let error = error {
                print("Error checking like status: \(error.localizedDescription)")
                return
            }

            if let document = document, document.exists {
                // Post is already liked by the user, so unlike it
                postRef.collection("likes").document(userID).delete() { error in
                    if let error = error {
                        print("Error unliking post: \(error.localizedDescription)")
                    } else {
                        userRef.collection("likes").document(postID).delete() { error in
                            if let error = error {
                                print("Error removing liked post from user's collection: \(error.localizedDescription)")
                            } else {
                                print("Post unliked successfully!")
                            }
                        }
                    }
                }
            } else {

                postRef.collection("likes").document(userID).setData([:]) { error in
                    if let error = error {
                        print("Error liking post: \(error.localizedDescription)")
                    } else {
                        userRef.collection("likes").document(postID).setData([:]) { error in
                            if let error = error {
                                print("Error adding liked post to user's collection: \(error.localizedDescription)")
                            } else {
                                print("Post liked successfully!")
                            }
                        }
                    }
                }
            }
        }
    }
    func repostPost(postID: String) {
        let userID = Auth.auth().currentUser!.uid
        let db = Firestore.firestore()
        let postRef = db.collection("Posts").document(postID)
        let userRef = db.collection("Users").document(userID)

        // Fetch the post document
        postRef.getDocument { (document, error) in
            if let document = document, document.exists {
                // Get the current repostCount
                let currentRepostCount = document.data()?["repostCount"] as? Int ?? 0

                // Update the repostCount
                let newRepostCount = currentRepostCount + 1
                postRef.updateData(["repostCount": newRepostCount]) { error in
                    if let error = error {
                        print("Error updating repostCount: \(error.localizedDescription)")
                    } else {
                        // Add the user's ID to the post's reposts subcollection
                        postRef.collection("reposts").document(userID).setData([:]) { error in
                            if let error = error {
                                print("Error adding user to reposts subcollection: \(error.localizedDescription)")
                            } else {
                                // Add the reposted post's ID to the user's reposts collection
                                userRef.collection("reposts").document(postID).setData([:]) { error in
                                    if let error = error {
                                        print("Error adding reposted post to user's reposts collection: \(error.localizedDescription)")
                                    } else {
                                        print("Post reposted successfully!")
                                    }
                                }
                            }
                        }
                    }
                }
            } else {
                print("Post not found")
            }
        }
    }

    // Call the function to fetch a specific user's posts
    func createComment(postID: String, commentText: String)  {

        let db = Firestore.firestore()
        let commenterUid = Auth.auth().currentUser!.uid
       
        
        // Define a dictionary to represent the comment data
        let commentData: [String: Any] = [
          
            "commenterUid": commenterUid, // Use the current user's UID
            "text": commentText, // Use the commentText parameter
            "timeSent": Timestamp(date: Date()), // Use the current date and time
            "commentReposts": 0, // You can set initial values here
            "commentLikes": 0
        ]

        // Reference to the post document
        let postRef = db.collection("Posts").document(postID)

        // Add the comment data to the comments subcollection of the post
        postRef.collection("comments").addDocument(data: commentData) { error in
            if let error = error {
                print("Error adding comment: \(error)")
            } else {
                print("Comment added successfully")
            }
        }
    }

    // Add more @Published properties as needed for other post data


    func listenToComments(forPost postId: String, completion: @escaping ([Comment]) -> Void) -> ListenerRegistration {
        let db = Firestore.firestore()
        let commentsRef = db.collection("Posts").document(postId).collection("comments")

        let listener = commentsRef
            .order(by: "timeSent", descending: false)
            .addSnapshotListener { querySnapshot, error in
                guard let snapshot = querySnapshot else {
                    print("Error listening for comment updates: \(error?.localizedDescription ?? "No error")")
                    return
                }

                // Create a task to handle asynchronous fetching
                Task {
                    var comments: [Comment] = []
                    for document in snapshot.documents {
                        do {
                            var comment = try document.data(as: Comment.self)
                            // Assuming `commenterUid` is a property of `Comment`
                            // and `fetchUsername` returns an optional string
                            comment.username = try await self.fetchUsername(for: comment.commenterUid)
                            comment.pfpUrl = try await self.fetchPfpUrl(for: comment.commenterUid)
                            comments.append(comment)
                        } catch {
                            print("Error decoding comment or fetching username: \(error)")
                        }
                    }
                    // Call the completion handler on the main thread with the updated comments
                    DispatchQueue.main.async {
                        completion(comments)
                    }
                }
            }

        return listener
    }


    
    func relativeTimeString(from timestamp: Timestamp) -> String {
        let date = timestamp.dateValue()
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.minute, .hour, .day, .weekOfYear], from: date, to: now)

        if let week = components.weekOfYear, week >= 1 {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            return dateFormatter.string(from: date)
        } else if let day = components.day, day >= 1 {
            return "\(day) day\(day > 1 ? "s" : "") ago"
        } else if let hour = components.hour, hour >= 1 {
            return "\(hour) hour\(hour > 1 ? "s" : "") ago"
        } else if let minute = components.minute, minute >= 1 {
            return "\(minute) minute\(minute > 1 ? "s" : "") ago"
        } else {
            return "Just now"
        }
    }
    func fetchUsername(for userId: String) async throws -> String {
        
           let userDocument = Userdb.document(userId)
           
           let documentSnapshot = try await userDocument.getDocument()
           
           guard let username = documentSnapshot.data()?["username"] as? String else {
               throw NSError(domain: "UserDataService", code: 0, userInfo: [NSLocalizedDescriptionKey: "Username not found"])
           }
           
           return username
       }
    func fetchPfpUrl(for userId: String) async throws -> String {
        
           let userDocument = Userdb.document(userId)
           
           let documentSnapshot = try await userDocument.getDocument()
           
           guard let pfpUrl = documentSnapshot.data()?["pfpUrl"] as? String else {
               throw NSError(domain: "UserDataService", code: 0, userInfo: [NSLocalizedDescriptionKey: "Username not found"])
           }
           
           return pfpUrl
       }

}



