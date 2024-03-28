//
//  Product.swift
//  OnCampApp
//
//  Created by Michael Washington on 11/4/23.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Product: Identifiable, Codable {
    @DocumentID var id: String?
    var name: String
    var category: String
    var description: String
    var image: String
    var price: Double

}


