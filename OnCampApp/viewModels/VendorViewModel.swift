//
//  VendorViewModel.swift
//  OnCampApp
//
//  Created by Michael Washington on 1/17/24.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

@MainActor
class VendorViewModel: ObservableObject {
    @Published var products: [Products] = []
    private var db = Firestore.firestore()
   
   
    
    
     
    
    func fetchAllProducts(forVendor vendorId: String) async throws -> [Products] {
           let vendorProductsRef = db.collection("Vendors").document(vendorId).collection("Products")
           let querySnapshot = try await vendorProductsRef.getDocuments()
           // When u use doc Ids you have to do this for sum reason
           let products: [Products] = querySnapshot.documents.compactMap { document in
               do {
                   return try document.data(as: Products.self)
               } catch {
                   print("Error decoding product: \(error)")
                   return nil
               }
           }
           
           print("DebugProducts:::\(products)")
           return products
       }
}

