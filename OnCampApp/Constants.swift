//
//  Constants.swift
//  OnCampApp
//
//  Created by Michael Washington on 10/31/23.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore
let Userdb = Firestore.firestore().collection("Users")
let Postdb = Firestore.firestore().collection("Posts")
let Vendordb = Firestore.firestore().collection("Vendors")
let Chatdb = Firestore.firestore().collection("Chats")
let Eventdb = Firestore.firestore().collection("Events")
let loggedInUid = Auth.auth().currentUser?.uid
let db = Firestore.firestore()
let Followingdb = db.collection("Following")
let Followerdb = db.collection("Follower")
let Favoritedb = db.collection("Favorites")
//let UserChats = db.collection("")
