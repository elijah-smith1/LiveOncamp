import Foundation
import Firebase
import FirebaseFirestoreSwift
import FirebaseFirestore

@MainActor
class VendorData: ObservableObject {
    @Published var vendorsByCategory: [String: [Vendor]] = [:]
    
    func fetchVendorIds() async throws -> [String] {
        var vendorIds = [String]()
        let snapshot = try await Vendordb.getDocuments()
        for document in snapshot.documents { vendorIds.append(document.documentID) }
        print(vendorIds)
        return vendorIds
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
            category: data["category"] as? [String] ?? [], // Changed to [String]
            rating: data["rating"] as? Double ?? 0.0,
            featured: data["featured"] as? Bool ?? false,
            pfpUrl: data["pfpUrl"] as? String ?? ""
        )
    }
    
    func fetchAllProducts(forVendor vendorId: String) async throws -> [Products] {
        let db = Firestore.firestore()
        let vendorProductsRef = db.collection("Vendors").document(vendorId).collection("Products")

        do {
            let querySnapshot = try await vendorProductsRef.getDocuments()
            let products = querySnapshot.documents.compactMap { document -> Products? in
                do {
                    return try document.data(as: Products.self)
                } catch {
                    print("Error decoding product \(document.documentID): \(error)")
                    return nil
                }
            }
            print("Fetched products for vendor \(vendorId): \(products)")
            return products
        } catch {
            print("Error fetching products for vendor \(vendorId): \(error.localizedDescription)")
            throw NSError(domain: "ProductFetchError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch products: \(error.localizedDescription)"])
        }
    }

    func deleteProduct(fromVendor vendorId: String, productId: String) async throws {
        let db = Firestore.firestore()
        let productRef = db.collection("Vendors").document(vendorId).collection("Products").document(productId)

        do {
            try await productRef.delete()
            print("Product successfully deleted")
        } catch {
            print("Error deleting product: \(error.localizedDescription)")
            throw NSError(domain: "ProductDeleteError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to delete product: \(error.localizedDescription)"])
        }
    }

    func addProduct(toVendor vendorId: String, product: Products) async throws {
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
            print("Error adding product: \(error.localizedDescription)")
            throw NSError(domain: "ProductAddError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to add product: \(error.localizedDescription)"])
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
                    "category": vendor.category, // This is now an array
                    "rating": vendor.rating,
                    "pfpUrl": vendor.pfpUrl
                ]) { err in
                    if let err = err {
                        print("Error updating vendor: \(err.localizedDescription)")
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
                    "headerImage": vendor.headerImage,
                    "category": vendor.category, // This is now an array
                    "rating": vendor.rating,
                    "pfpUrl": vendor.pfpUrl
                ]) { err in
                    if let err = err {
                        print("Error creating new vendor: \(err.localizedDescription)")
                    } else {
                        print("Vendor successfully created")
                    }
                }
            }
        }
    }
}
