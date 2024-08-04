import Foundation
import Firebase
import FirebaseFirestore

@MainActor
class feedViewModel: ObservableObject {
    @Published var Posts: [Post] = []
    @Published var FollowingPosts: [Post] = []
    @Published var mixedFeedItems: [AnyFeedItem] = []
    @Published var errorMessage: String?
    
    func fetchFollowingPosts() async {
        do {
            let userIds = try await UserData.getFollowingDocumentIds()
            self.FollowingPosts = try await PostData.fetchPostsForIds(for: userIds)
        } catch {
            errorMessage = "Error fetching following posts: \(error.localizedDescription)"
            print(errorMessage ?? "")
        }
    }
    
    func fetchFavoritePosts() async {
        do {
            let userIds = try await UserData.getFavoriteDocumentIds()
            self.Posts = try await PostData.fetchPostsForIds(for: userIds)
        } catch {
            errorMessage = "Error fetching favorite posts: \(error.localizedDescription)"
            print(errorMessage ?? "")
        }
    }
    
    func fetchPublicPosts() async {
        do {
            self.Posts = try await PostData.fetchPublicPosts()
        } catch {
            errorMessage = "Error fetching public posts: \(error.localizedDescription)"
            print(errorMessage ?? "")
        }
    }
    
    func fetchMixedFeedItems() async {
        do {
            // Fetch posts
            let posts = try await PostData.fetchPublicPosts()
            
            // Fetch vendors
            let vendorData = VendorData()
            let vendorIds = try await vendorData.fetchVendorIds()
            let vendors = try await withThrowingTaskGroup(of: Vendor?.self) { group in
                for id in vendorIds.prefix(5) {
                    group.addTask {
                        try? await vendorData.getVendorData(vendorID: id)
                    }
                }
                return try await group.compactMap { $0 }.reduce(into: []) { $0.append($1) }
            }
            
            // Fetch products
            let products = try await fetchProducts(limit: 10)

            // Mix items
            var items: [AnyFeedItem] = []
            var postCounter = 0

            for post in posts {
                items.append(AnyFeedItem(post))
                postCounter += 1

                if postCounter % 10 == 0 {
                    if let vendor = vendors.randomElement() {
                        items.append(AnyFeedItem(vendor))
                    }
                    if let product = products.randomElement() {
                        items.append(AnyFeedItem(product))
                    }
                }
            }

            self.mixedFeedItems = items
        } catch {
            errorMessage = "Error fetching mixed feed items: \(error.localizedDescription)"
            print(errorMessage ?? "")
        }
    }
    
    private func fetchProducts(limit: Int) async throws -> [Products] {
        let db = Firestore.firestore()
        let snapshot = try await db.collection("Products").limit(to: limit).getDocuments()
        return try snapshot.documents.compactMap { try $0.data(as: Products.self) }
    }
}
