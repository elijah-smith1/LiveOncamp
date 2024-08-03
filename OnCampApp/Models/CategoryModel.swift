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
    CategoryModel(icon: "scissors", title: "Hair & Beauty"),
    CategoryModel(icon: "tshirt", title: "Fashion"),
    CategoryModel(icon: "cart", title: "Retail"),
    CategoryModel(icon: "fork.knife", title: "Food & Beverage"),
    CategoryModel(icon: "book", title: "Education"),
    CategoryModel(icon: "laptop", title: "Tech Services"),
    CategoryModel(icon: "paintbrush", title: "Art & Design"),
    CategoryModel(icon: "figure.walk", title: "Fitness"),
    CategoryModel(icon: "camera", title: "Photography"),
    CategoryModel(icon: "car", title: "Transportation"),
    CategoryModel(icon: "wrench", title: "Repairs"),
    CategoryModel(icon: "music.note", title: "Entertainment"),
    CategoryModel(icon: "gift", title: "Events & Gifts"),
    CategoryModel(icon: "dollarsign.circle", title: "Financial Services"),
    CategoryModel(icon: "bed.double", title: "Housing"),
    CategoryModel(icon: "leaf", title: "Eco-Friendly"),
    CategoryModel(icon: "person.2", title: "Social Services"),
    CategoryModel(icon: "briefcase", title: "Professional Services"),
    CategoryModel(icon: "pencil", title: "Tutoring")
]
// Category list for Social
var socialcategoryList: [CategoryModel] = [
    CategoryModel(icon: "circle", title: "All"),
    CategoryModel(icon: "trophy", title: "Tournaments"),
    CategoryModel(icon: "building.columns", title: "School"),
    CategoryModel(icon: "party.popper", title: "Parties"),
]
