//
//  VendorModel.swift
//  OnCampApp
//
//  Created by Elijah and Mike on 2/12/24.
//
import Foundation
import Firebase
import FirebaseFirestoreSwift
import FirebaseFirestore


struct Vendor: Identifiable {
    @DocumentID var id: String?
    var description: String
    var schools: [String]
    var name: String
    var headerImage: String
    var category: String
    var rating: Double
    var featured: Bool
    var pfpUrl: String// New field
}
