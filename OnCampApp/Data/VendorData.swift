//
//  VendorData.swift
//  OnCampApp
//
//  Created by Elijah Smith on 11/14/23.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import FirebaseFirestore


@MainActor
class VendorData: ObservableObject{
    
    @Published var vendorsByCategory: [String: [Vendor]] = [:]
    
    
    func fetchVendorIds() async throws -> [String] {
        var vendorIds = [String]()
        let snapshot = try await Vendordb.getDocuments()
        for document in snapshot.documents { vendorIds.append(document.documentID) }
        print(vendorIds);return vendorIds
    }

    
    func getVendorData(vendorID: String) async throws -> Vendor {
        let db = Firestore.firestore()
        let vendorRef = db.collection("Vendors").document(vendorID)

        let document = try await vendorRef.getDocument()
        
        guard let data = document.data(), document.exists else {
            throw NSError(domain: "VendorError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Document does not exist"])
        }
            print("Debug::: \(data)")
        return Vendor(
            id: document.documentID,
            description: data["description"] as? String ?? "",
            schools: data["schools"] as? [String] ?? [],
            name: data["name"] as? String ?? "",
            headerImage: data["headerImage"] as? String ?? "",
            category: data["category"] as? String ?? "",
            rating: data["rating"] as? Double ?? 0.0,
            featured: data["featured"] as? Bool ?? false,
            pfpUrl: data["pfpUrl"] as? String ?? ""
        
        )
        
    }
    
    func fetchAllProducts(forVendor vendorId: String) async throws -> [Product] {
        let db = Firestore.firestore()
        let vendorProductsRef = db.collection("Vendors").document(vendorId).collection("Products")

        let querySnapshot = try await vendorProductsRef.getDocuments()
        let products = querySnapshot.documents.compactMap { document -> Product? in
            // Attempt to decode the document into a Product
            try? document.data(as: Product.self)
        }
        print(products)
        return products
    }

    func deleteProduct(fromVendor vendorId: String, productId: String) async throws {
        let db = Firestore.firestore()
        let productRef = db.collection("Vendors").document(vendorId).collection("Products").document(productId)

        do {
            try await productRef.delete()
            print("Product successfully deleted")
        } catch {
            throw error
        }
    }

    
    func addProduct(toVendor vendorId: String, product: Product) async throws {
        let db = Firestore.firestore()
        let vendorProductsRef = db.collection("Vendors").document(vendorId).collection("Products")

        let newProductData: [String: Any] = [
            "name": product.name,
            "category": product.category,
            "description": product.description,
            "image": product.image,
            "price": product.price
        ]

        do {
            _ = try await vendorProductsRef.addDocument(data: newProductData)
            print("Product successfully added")
        } catch {
            throw error
        }
    }

    

    func updateVendorInfo(vendor: Vendor) {
        guard let vendorID = vendor.id else {
            print("Vendor ID is missing.")
            return
        }

        let db = Firestore.firestore()
        let vendorRef = db.collection("Vendors").document(vendorID)

        // Check if the document exists
        vendorRef.getDocument { (document, error) in
            if let document = document, document.exists {
                // Document exists, update it
                vendorRef.updateData([
                    "description": vendor.description,
                    "schools": vendor.schools,
                    "name": vendor.name,
                    "headerImage": vendor.headerImage,
                    "category": vendor.category,
                    "rating": vendor.rating,
                    "pfpUrl": vendor.pfpUrl

                ]) { err in
                    if let err = err {
                        print("Error updating vendor: \(err)")
                    } else {
                        print("Vendor successfully updated")
                    }
                }
            } else {
                // Document does not exist, create a new one
                vendorRef.setData([
                    "description": vendor.description,
                    "schools": vendor.schools,
                    "name": vendor.name,
                    "image": vendor.headerImage,
                    "category": vendor.category,
                    "rating": vendor.rating,
                    "pfpUrl": vendor.pfpUrl
                ]) { err in
                    if let err = err {
                        print("Error creating new vendor: \(err)")
                    } else {
                        print("Vendor successfully created")
                    }
                }
            }
        }
    }

   

    
    
   
    
}

