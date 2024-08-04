//
//  FeedItem.swift
//  OnCampApp
//
//  Created by Michael Washington on 8/4/24.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

protocol FeedItem: Identifiable {
    var feedItemId: String { get }
    associatedtype ContentView: View
    @ViewBuilder var contentView: ContentView { get }
}

// Extend Post to conform to FeedItem
extension Post: FeedItem {
    var feedItemId: String {
        return self.id ?? UUID().uuidString
    }
    
    var contentView: some View {
        PostCell(post: self)
    }
}

// Extend Vendor to conform to FeedItem
extension Vendor: FeedItem {
    var feedItemId: String {
        return self.id ?? UUID().uuidString
    }
    
    var contentView: some View {
        VendorPreview(vendor: self)
    }
}

// Extend Products to conform to FeedItem
extension Products: FeedItem {
    var feedItemId: String {
        return self.id ?? UUID().uuidString
    }
    
    var contentView: some View {
        SmallProductCard(product: self)
    }
}

// Type-erased wrapper for FeedItem
struct AnyFeedItem: Identifiable {
    let id: String
    let contentView: AnyView
    
    init<T: FeedItem>(_ feedItem: T) {
        self.id = feedItem.feedItemId
        self.contentView = AnyView(feedItem.contentView)
    }
}
