//
//  CategoryModel.swift
//  OnCampApp
//
//  Created by Michael Washington on 11/4/23.
//

import Foundation

struct CategoryModel: Identifiable, Hashable {
    var id: UUID = .init()
    var icon: String
    var title: String
}

struct SocialCategoryModel: Identifiable, Hashable {
    var id: UUID = .init()
    var icon: String
    var title: String
}

// Category list for Marketplace
var categoryList: [CategoryModel] = [
    CategoryModel(icon: "circle", title: "All"),
    CategoryModel(icon: "scissors", title: "Hair"),
    CategoryModel(icon: "tshirt", title: "Clothes"),
    CategoryModel(icon: "cart", title: "Store"),
    CategoryModel(icon: "leaf", title: "AUCS"),
]

// Category list for Social
var socialcategoryList: [CategoryModel] = [
    CategoryModel(icon: "circle", title: "All"),
    CategoryModel(icon: "trophy", title: "Tournaments"),
    CategoryModel(icon: "building.columns", title: "School"),
    CategoryModel(icon: "party.popper", title: "Parties"),
]
